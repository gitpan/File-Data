#
# File::Data tests
# <C> Richard Foley RFI 2001 richard.foley@rfi.net
# $Id: test.t,v 1.7 2002/02/20 15:15:47 richard Exp $ 
# 

use lib '/home/richard';
use Data::Dumper;
use File::Data;
use Test;
use strict;

plan('tests' => 16);

my $i_test = 0;
my $i_errs = 0;

$File::Data::FATAL=0;
$File::Data::REFERENCE=0;

my $rj = './t/japh';
my $ro = './t/read';
my $rp = './t/perms';
my $rt = './t/rjsf-'.$$.'_'.time;
my $rw = './t/write';
my $rx = './t/extra';

# CREATE (open) our files - with valid permissions
# =============================================================================
$i_test++; # 1
$i_errs = 0;

foreach my $perm (qw(ro > <)) {
	my $o_ro = File::Data->new($ro, $perm); 		# read 
	unless (ref($o_ro)) {
		$i_errs++;
		print "[$i_test] failed read-only file($ro, $perm) => o_ro($o_ro)\n"; 
	}
}
($i_errs == 0) ? ok(1) : ok(0);

foreach my $perm ('', qw(rw +< +>)) {
	my $o_rw = File::Data->new($rw, $perm); 		# write
	unless (ref($o_rw)) {
		$i_errs++;
		print "[$i_test] failed read-write file($rw, $perm) => o_rw($o_rw)\n"; 
	}
}
($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

# $o_rx = undef; # how to close the file
# $o_rx->close;

# LOCK (ed)
# =============================================================================
$i_test++; # 2
$i_errs = 0;
{
	$File::Data::SILENT=1;
	my %file = (
	 'read'		=> File::Data->new($ro, 'ro'),
	 'write'	=> File::Data->new($rw),
	);
	foreach my $key (sort keys %file) { # cannot read/write twice 
		my $orig = $file{$key}->_var('filename');
		my $o_new = File::Data->new($orig);
		if ($o_new) {
			$i_errs++;
			print "[$i_test] re-read($orig) => o_new($o_new)!\n"; 
		}
	}
	$File::Data::SILENT=0;
}
($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

# PERM (issions) _check_access
# =============================================================================
$i_test++; # 3
$i_errs = 0;
{
	$File::Data::SILENT=1;
	foreach my $file ('', $rt, qw()) {
		my $o_rp = File::Data->new('', '<');		# invalid filename 
		if ($o_rp) {
			$i_errs++; 
			print "[$i_test] invalid file() => o_rp($o_rp)\n";
		}
	}
}
($i_errs == 0) ? ok(1) : ok(0);

{	# things that _might_ look like valid permissions to someone else
	foreach my $perms ($ro, $rw, $rt, qw(>+< ++ <> <+ - rad read write rww roo)) {
		my $o_rp = File::Data->new($rp, $perms);	# invalid perms
		if ($o_rp) {
			$i_errs++;
			print "[$i_test] invalid permissions($perms) accepted => o_rp($o_rp)\n"; 
		}
	}
}
($i_errs == 0) ? ok(1) : ok(0);

{
	foreach my $dir (qw(t .. ../)) {				# rjsf - un*x only?
		my $o_rp = File::Data->new($dir);			# dirs
		if ($o_rp) {
			$i_errs++;
			print "[$i_test] invalid directory(t) accepted => o_rp($o_rp)\n"; 
		}
	}
}
($i_errs == 0) ? ok(1) : ok(0);

{
	# $File::Data::SILENT=1;
	foreach my $perm ('0000'..'0777') { # 
		next if $perm =~ /[89]/; # :-\
		my $i_cnt = chmod oct($perm), $rp;
		if ($i_cnt != 1) {
			$i_errs++;
			print "[$i_test] failed($i_cnt) to chmod($perm, $rp)\n"; 
		} else {
			my $o_rp = File::Data->new($rp);			# perms
			unless ((!$o_rp && $perm <= '0577') || 
					( $o_rp && $perm >= '0600')) {
				$i_errs++;
				print "[$i_test] invalid file($rp) perm($perm) => o_rp($o_rp)\n"; 
			}
		}
	}
	# $File::Data::SILENT=0;
}
($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

# READ (only)
# =============================================================================
$i_test++; # 4
$i_errs = 0;
{
	my @data = ( "first\n", "second\n", "etc.\n",);
	my $i_wr = my @writ = File::Data->new($ro)->WRITE(@data);
	unless ($i_wr == 3) {
		$i_errs++;
		print "[$i_test] read not primed $i_wr lines\n".Dumper(\@writ);
	}
	my $i_ro = my @read = File::Data->new($ro, 'ro')->READ('.+');
	unless ($i_ro >= 3) {
		$i_errs++;
		print "[$i_test] read contains $i_ro lines\n".Dumper(\@read);
	}

	my $i_RO = my @READ = File::Data->new($ro, 'ro')->read('.+')->RETURN('read');
	unless ($i_RO >= 3) {
		$i_errs++;
		print "[$i_test] READ contains $i_RO lines\n".Dumper(\@READ); 
	}
}

($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

# WRITE
# =============================================================================
$i_test++; # 5
$i_errs = 0;
{
	my @write = (
		"here is some irrelevant\n",
		"test data that should end up in the file\n",
		"\n",
		"somewhere\n",
	);
	my $i_wr = my @writ = File::Data->new($rw)->WRITE(@write);
	unless ($i_wr == 4) {
		$i_errs++;
		print "[$i_test] write contains $i_wr lines(@writ)\n"; 
	}

	my $i_WR = my @WRIT = File::Data->new($rx)->write('xyz')->write(@write)->RETURN('write');
	unless ($i_WR == 4) {
		$i_errs++;
		print "[$i_test] WRITE contains $i_WR lines(@WRIT)\n"; 
	}
}

($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

# ACCESS (write to read-only)
# =============================================================================
$i_test++; # 6
$i_errs = 0;

{
	$File::Data::SILENT=1;
	my $o_ro = File::Data->new($ro, 'ro');
	foreach my $attempt (qw(APPEND INSERT PREPEND REPLACE WRITE)) {
		my $i_x = my @x = $o_ro->$attempt("bad $attempt ", "bad stuff");
		if ($i_x || @x) {
			$i_errs++;
			print "wrote($attempt) to read-only($i_x) file(@x)!\n";
		}
	}
	$File::Data::SILENT=0;
}

($i_errs == 0) ? ok(1) : ok(0);
#  =============================================================================

# PREPEND
# =============================================================================
$i_test++; # 7
$i_errs = 0;
{
	my $o_rw = File::Data->new($rw);
	my $pre = "prepended this stuff\n";
	my $i_pre = my @pre = $o_rw->PREPEND($pre);
	unless ($pre[0] eq $pre) {
		$i_errs++;
		print "[$i_test] prepend(@pre)\n"; 
	}

	my $o_rx = File::Data->new($rx);
	my $i_PRE = my @PRE = $o_rx->prepend($pre)->RETURN('prepend');
	unless ($PRE[0] eq $pre) {
		$i_errs++;
		print "[$i_test] prepend(@PRE)\n"; 
	}
}

($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

# INSERT
# =============================================================================
$i_test++; # 8
$i_errs = 0;

{
	my $o_rw = File::Data->new($rw);
	my $ins = "inserted some stuff at line 2\n";
	my $i_ins = my @ins = $o_rw->INSERT(2, $ins); 
	unless ($ins[0] eq $ins) {
		$i_errs++;
		print "[$i_test] insert(@ins)\n";
	}

	my $o_rx = File::Data->new($rx);
	my $i_INS = my @INS = $o_rx->insert(2, $ins)->RETURN('insert'); 
	unless ($INS[0] eq $ins) {
		$i_errs++;
		print "[$i_test] INSERT(@INS)\n"; 
	}
}

($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

# APPEND
# =============================================================================
$i_test++; # 9
$i_errs = 0;

{
	my $o_rw = File::Data->new($rw);
	my $app = "appended that stuff\n";
	my $i_app = my @app = $o_rw->APPEND($app);
	unless ($app[0] eq $app) {
		$i_errs++;
		print "[$i_test] append(@app)\n"; 
	} 
	my $o_rx = File::Data->new($rx);
	my $i_APP = my @APP = $o_rx->append($app)->RETURN('append');
	unless ($APP[0] eq $app) {
		$i_errs++;
		print "[$i_test] APPEND(@APP)\n"; 
	}
}

($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

# SEARCH
# =============================================================================
$i_test++; # 10
$i_errs = 0;
{
	$File::Data::STRING = 0;
	my $o_rw = File::Data->new($rw);
	my $str0 = 'ed\s*(\w+\s*\w{2})uff';
	my $i_str0 = my @str0 = $o_rw->SEARCH($str0);
	unless ($str0[1] eq 'some st') {
		$i_errs++;
		print "str0($str0): err($i_errs) ".Dumper(\@str0); 
	}

	$File::Data::STRING = 1;
	my $str1 = '(?ms:line\s*(\d+)\s*(\w+))';
	my $i_str1 = my @str1 = $o_rw->SEARCH($str1);
	unless ($str1[0] == 2 && $str1[1] eq 'test') {
		$i_errs++;
		print "str1($str1): err($i_errs) ".Dumper(\@str1); 
	}
}
# rjsf - SEARCH

($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

# REPLACE
# =============================================================================
$i_test++; # 11
$i_errs = 0;
{
	$File::Data::STRING = 0;
	my $o_rw = File::Data->new($rw);
	my $sea0 = '(ed)\s+'; my $rep0 = 'ED ';
	my $i_sea0 = my @snr0 = $o_rw->REPLACE($sea0 => $rep0);
	unless ($snr0[2] =~ /^insertED some stuff at line 2$/) {
		$i_errs++;
		print "sea0($sea0) rep($rep0): i($i_sea0) err($i_errs) ".Dumper(\@snr0);
	}

	$File::Data::STRING = 1;
	my $sea1 = '(ED)\s+'; my $rep1 = 'Ed ';
	my $i_sea1 = my @snr1 = $o_rw->REPLACE($sea1 => $rep1);
	unless ($snr1[0] =~ /insertEd some stuff at line 2/s) {
		$i_errs++;
		print "sea1($sea1) rep($rep1): i($i_sea1) err($i_errs) ".Dumper(\@snr1); 
	}
}
# rjsf - REPLACE 

($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

# Feedback 
# =============================================================================
$i_test++; # 12
$i_errs = 0;
{
	my $o_rw = File::Data->new($rw);
	print $o_rw->_vars if $File::Data::DEBUG;
}
($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================

package File::Data::Test;

sub new { return  bless({}, shift); }

sub read {
	my $self = shift;
	my $err  = join('', @_);
	my $length = length($err);
	print "read failure handler - length($length):\n  $err\n";
}

sub error { # returns length of arg string/s
	my $self = shift;
	my $err  = join('', @_);
	my $length = length($err);
	print "error failure handler - length($length):\n  $err\n";
}

1;

# =============================================================================

__END__

# reuse
$i_test++; # 13
my $o_reuse = File::Data->new($rw);
print "[$i_test] re-use for file($rw) => o_reuse($o_reuse)\n";
(ref($o_reuse)) ? ok(4) : ok(0);

# error handler
$i_test++; # 14
undef $o_rw; # close it
my $o_err = File::Data->new('hopefully_NON-existent->file :-)',
		'open'		=> File::Data::Test->new,
		'init'		=> File::Data::Test->new,
		'extract'	=> File::Data::Test->new,
);
my $i_err = my @errs = $o_err->extract('.+');
print "[$i_test] err extract $i_err line/s (@errs)\n";
($i_err) ? ok(9) : ok(0);

# error handler
$i_test++; # 15
undef $o_rw; # close it
my $i_err = my @err = File::Data->new('hopefully_NON-existent->file :-)',
		'error'	=> \&error_handler,
	
)->extract('.+');
print "[$i_test] reread $i_read line/s (@read)\n";
($i_read == $i_wrote_cnt) ? ok(9) : ok(0);

sub error_handler {
	my $err  = join('', @_);
	print 'error_handler: '.length($err)."\n";
}

# done

=pod
# PERMs ()
# =============================================================================
$i_test++; # 3
$i_errs = 0;

my $o_rp = File::Data->new($rp, '>+<');	# perms
$i_errs++ unless ref($o_rp);
print "[$i_test] perms file($rp) => o_rp($o_rp)\n" if $i_errs;

# my $i_stat = my @stat = File::Data->new($ro)->FSTAT('_');
# $i_errs++ unless $i_stat >= 3; # rjsf
# print "[$i_test] stat(@stat): ".Dumper(\@stat) if $i_errs;

($i_errs == 0) ? ok(1) : ok(0);
# =============================================================================
=cut
