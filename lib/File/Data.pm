#!perl
#
# Documentation, copyright and license is at the end of this file.
#
package  File::Data;

use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE);
$VERSION = '1.1';
$DATE = '2003/07/04';

use File::Spec;
use File::PM2File;
use File::SmartNL;

######
#
#
sub pm2datah
{
    my (undef, $pm) = @_;
   
    #####
    #
    # Alternative:
    #    $fh = \*{"${svd_pm}::DATA"}; only works the first time load, thereafter, closed
    #
    # Only works the one time after loading a module. Thereafter it is closed. No rewinds.
    # 
    #
    my ($file) = File::PM2File->pm2file( $pm );

    unless( $file ) {
        warn "# Cannot find file for $pm\n";
        return undef;
    }

    local($/);
    $/ = "__DATA__";
    my $fh;
    unless( open $fh, "< $file" ) {
        warn "# Cannot open $file\n";
        return undef;
    }    
    binmode $fh;

    ######
    # Move to the __DATA__ token
    #
    my $data = 'Start Search';

    while($data && $data !~ /[\012\015]__DATA__$/ ) {
        $data =  <$fh>;
    }

    $fh
}

######
#
#
sub pm2data
{
    my (undef, $pm) = @_;
    my $fh = File::Data->pm2datah( $pm );
    my $data = File::SmartNL->fin($fh);
    close $fh;
    $data;
}




1


__END__


=head1 NAME

File::Data - access the __DATA__ section in a program module (PM)

=head1 SYNOPSIS

  use File::Data

  $fh   = File::FileUtil->pm2datah($pm_file)
  $data = File::FileUtil->pm2data($pm_file)

=head1 DESCRIPTION

There are times when the __DATA__ section of a program module (PM)
are needed. The "File::Data" methods provides such access.


=head2 pm2datah method

 $fh = File::FileUtil->pm2datah($pm_file)

The I<pm2datah> method will open the I<$pm_file> and
return a handle positioned at the first I</[\012\015]__DATA__/>
token occuring in the file.
This function is very similar to the I<DATA> file handle
that Perl creates when loading a module file with the
I</[\012\015]__DATA__/> token.
The differences is that I<pm2datah> works whether or
not the file module is loaded. 
The method does not close the file handle.
Unlike the I<DATA> file handle, which cannot be reused
after the module data is read the first time,
the I<pm2datah> will always return an opened file handle,
the first time, the second time, any time.

CAUTION: 

If the I</[\012\015]__DATA__/> token appears
in the code section, say in a comment, or as
a value assigned to a variable,
the I<pm2datah> method will misbehave.

=head2 pm2data method

 $data = File::FileUtil->pm2data($pm_file)

The I<pm2data> uses the L<I<pm2datah>|File::FileUtil/pm2datah>
to return all the data in a I<$pm_file> form the I<__DATA__>
token to the end of the file.

=head1 REQUIREMENTS

Coming soon.

=head1 DEMONSTRATION

 ~~~~~~ Demonstration overview ~~~~~

Perl code begins with the prompt

 =>

The selected results from executing the Perl Code 
follow on the next lines. For example,

 => 2 + 2
 4

 ~~~~~~ The demonstration follows ~~~~~

 =>     use File::Spec;

 =>     use File::Package;
 =>     my $fp = 'File::Package';

 =>     use File::SmartNL;
 =>     my $snl = 'File::SmartNL';

 =>     my $fd = 'File::Data';
 =>     my $loaded = '';
 => my $errors = $fp->load_package($fd)
 => $errors
 ''

 =>  $snl->fin( File::Spec->catfile( 'Drivers', 'Driver.pm' ) )
 '#!perl
 #
 #
 package  File::FileUtil::Drivers::Driver;

 use strict;
 use warnings;
 use warnings::register;

 use vars qw($VERSION $DATE $FILE );
 $VERSION = '0.02';
 $DATE = '2003/06/18';
 $FILE = __FILE__;

 __DATA__

 =head1 Title Page

  Software Version Description

  for

  ${TITLE}

  Revision: ${REVISION}

  Version: ${VERSION}

  Date: ${DATE}

  Prepared for: ${END_USER} 

  Prepared by:  ${AUTHOR}

  Copyright: ${COPYRIGHT}

  Classification: ${CLASSIFICATION}

 =cut
 '

 =>    my $fh = $fd->pm2datah('t::File::Drivers::Driver');
 =>    my $actual_datah = $snl->fin($fh);
 =>    $actual_datah =~ s/^\s*(.*)\s*$/$1/gs;
 => $actual_datah
 '=head1 Title Page

  Software Version Description

  for

  ${TITLE}

  Revision: ${REVISION}

  Version: ${VERSION}

  Date: ${DATE}

  Prepared for: ${END_USER} 

  Prepared by:  ${AUTHOR}

  Copyright: ${COPYRIGHT}

  Classification: ${CLASSIFICATION}

 =cut
 '

 =>    $actual_datah = $fd->pm2data('t::File::Drivers::Driver');
 =>    $actual_datah =~ s/^\s*(.*)\s*$/$1/gs;
 => $actual_datah
 '=head1 Title Page

  Software Version Description

  for

  ${TITLE}

  Revision: ${REVISION}

  Version: ${VERSION}

  Date: ${DATE}

  Prepared for: ${END_USER} 

  Prepared by:  ${AUTHOR}

  Copyright: ${COPYRIGHT}

  Classification: ${CLASSIFICATION}

 =cut
 '


=head1 QUALITY ASSURANCE

The module "t::File::Data" is the Software
Test Description(STD) module for the "File::Data".
module. 

To generate all the test output files, 
run the generated test script,
run the demonstration script and include it results in the "File::Data" POD,
execute the following in any directory:

 tmake -test_verbose -replace -run  -pm=t::File::Data

Note that F<tmake.pl> must be in the execution path C<$ENV{PATH}>
and the "t" directory containing  "t::File::Data" on the same level as 
the "lib" directory that
contains the "File::Data" module.

=head1 NOTES

=head2 AUTHOR

The holder of the copyright and maintainer is

E<lt>support@SoftwareDiamonds.comE<gt>

=head2 COPYRIGHT NOTICE

Copyrighted (c) 2002 Software Diamonds

All Rights Reserved

=head2 BINDING REQUIREMENTS NOTICE

Binding requirements are indexed with the
pharse 'shall[dd]' where dd is an unique number
for each header section.
This conforms to standard federal
government practices, 490A (L<STD490A/3.2.3.6>).
In accordance with the License, Software Diamonds
is not liable for any requirement, binding or otherwise.

=head2 LICENSE

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

=over 4

=item 1

Redistributions of source code must retain
the above copyright notice, this list of
conditions and the following disclaimer. 

=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

=back

SOFTWARE DIAMONDS, http::www.softwarediamonds.com,
PROVIDES THIS SOFTWARE 
'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL SOFTWARE DIAMONDS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL,EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE,DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING USE OF THIS SOFTWARE, EVEN IF
ADVISED OF NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE POSSIBILITY OF SUCH DAMAGE. 

=head2 SEE_ALSO:

=over 4

=item L<File::PM2File|File::PM2File>

=item L<File::SmartNL|File::SmartNL>

=back

=back
=for html
<p><br>
<!-- BLK ID="NOTICE" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="OPT-IN" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="EMAIL" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="COPYRIGHT" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>

=cut

### end of file ###