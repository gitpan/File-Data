#!perl
#
# The copyright notice and plain old documentation (POD)
# are at the end of this file.
#
package  t::File::Data;

use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE $FILE );
$VERSION = '0.02';
$DATE = '2004/04/09';
$FILE = __FILE__;

########
# The Test::STDmaker module uses the data after the __DATA__ 
# token to automatically generate the this file.
#
# Don't edit anything before __DATA_. Edit instead
# the data after the __DATA__ token.
#
# ANY CHANGES MADE BEFORE the  __DATA__ token WILL BE LOST
#
# the next time Test::STDmaker generates this file.
#
#


=head1 TITLE PAGE

 Detailed Software Test Description (STD)

 for

 Perl File::Data Program Module

 Revision: -

 Version: 

 Date: 2004/04/09

 Prepared for: General Public 

 Prepared by:  http://www.SoftwareDiamonds.com support@SoftwareDiamonds.com

 Classification: None

=head1 SCOPE

This detail STD and the 
L<General Perl Program Module (PM) STD|Test::STD::PerlSTD>
establishes the tests to verify the
requirements of Perl Program Module (PM) L<File::Data|File::Data>

The format of this STD is a tailored L<2167A STD DID|Docs::US_DOD::STD>.
in accordance with 
L<Detail STD Format|Test::STDmaker/Detail STD Format>.

#######
#  
#  4. TEST DESCRIPTIONS
#
#  4.1 Test 001
#
#  ..
#
#  4.x Test x
#
#

=head1 TEST DESCRIPTIONS

The test descriptions uses a legend to
identify different aspects of a test description
in accordance with
L<STD FormDB Test Description Fields|Test::STDmaker/STD FormDB Test Description Fields>.

=head2 Test Plan

 T: 4^

=head2 ok: 1


  C:
     use File::Spec;
     use File::Package;
     my $fp = 'File::Package';
     use File::SmartNL;
     my $snl = 'File::SmartNL';
     my $fd = 'File::Data';
     my $loaded = '';
 ^
 VO: ^

  C:
    my $expected_datah = << 'EOF';
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
 EOF
 $expected_datah =~ s/^^\s*(.*)\s*$/$1/gs;
 ^
  N: UUT not loaded^
  A: $loaded = $fp->is_package_loaded($fd)^
  E:  ''^
 ok: 1^

=head2 ok: 2

  N: Load UUT^
  S: $loaded^
  C: my $errors = $fp->load_package($fd)^
  A: $errors^
 SE: ''^
 ok: 2^

=head2 ok: 3

 DO: ^
  A:  $snl->fin( File::Spec->catfile( '_Drivers_', 'Driver.pm' ) )^
  N: pm2datah^

  C:
    my $fh = $fd->pm2datah('_Drivers_::Driver');
    my $actual_datah = $snl->fin($fh);
    $actual_datah =~ s/^^\s*(.*)\s*$/$1/gs;
 ^
  A: $actual_datah^
  E: $expected_datah^
 ok: 3^

=head2 ok: 4

  N: pm2data^

  C:
    $actual_datah = $fd->pm2data('_Drivers_::Driver');
    $actual_datah =~ s/^^\s*(.*)\s*$/$1/gs;
 ^
  A: $actual_datah^
  E: $expected_datah^
 ok: 4^



#######
#  
#  5. REQUIREMENTS TRACEABILITY
#
#

=head1 REQUIREMENTS TRACEABILITY

  Requirement                                                      Test
 ---------------------------------------------------------------- ----------------------------------------------------------------


  Test                                                             Requirement
 ---------------------------------------------------------------- ----------------------------------------------------------------


=cut

#######
#  
#  6. NOTES
#
#

=head1 NOTES

copyright © 2003 Software Diamonds.

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

=over 4

=item 1

Redistributions of source code, modified or unmodified
must retain the above copyright notice, this list of
conditions and the following disclaimer. 

=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

=back

SOFTWARE DIAMONDS, http://www.SoftwareDiamonds.com,
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

#######
#
#  2. REFERENCED DOCUMENTS
#
#
#

=head1 SEE ALSO

L<File::Data>

=back

=for html
<hr>
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
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>

=cut

__DATA__

File_Spec: Unix^
UUT: File::Data^
Revision: -^
End_User: General Public^
Author: http://www.SoftwareDiamonds.com support@SoftwareDiamonds.com^
Detail_Template: ^
STD2167_Template: ^
Version: ^
Classification: None^
Temp: temp.pl^
Demo: Data.d^
Verify: Data.t^


 T: 4^


 C:
    use File::Spec;

    use File::Package;
    my $fp = 'File::Package';

    use File::SmartNL;
    my $snl = 'File::SmartNL';

    my $fd = 'File::Data';
    my $loaded = '';
^

VO: ^

 C:
   my $expected_datah = << 'EOF';
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
EOF

$expected_datah =~ s/^^\s*(.*)\s*$/$1/gs;
^

 N: UUT not loaded^
 A: $loaded = $fp->is_package_loaded($fd)^
 E:  ''^
ok: 1^

 N: Load UUT^
 S: $loaded^
 C: my $errors = $fp->load_package($fd)^
 A: $errors^
SE: ''^
ok: 2^

DO: ^
 A:  $snl->fin( File::Spec->catfile( '_Drivers_', 'Driver.pm' ) )^
 N: pm2datah^

 C:
   my $fh = $fd->pm2datah('_Drivers_::Driver');
   my $actual_datah = $snl->fin($fh);
   $actual_datah =~ s/^^\s*(.*)\s*$/$1/gs;
^

 A: $actual_datah^
 E: $expected_datah^
ok: 3^

 N: pm2data^

 C:
   $actual_datah = $fd->pm2data('_Drivers_::Driver');
   $actual_datah =~ s/^^\s*(.*)\s*$/$1/gs;
^

 A: $actual_datah^
 E: $expected_datah^
ok: 4^


See_Also: L<File::Data>^

Copyright:
copyright © 2003 Software Diamonds.

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

=over 4

=item 1

Redistributions of source code, modified or unmodified
must retain the above copyright notice, this list of
conditions and the following disclaimer. 

=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

=back

SOFTWARE DIAMONDS, http://www.SoftwareDiamonds.com,
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
^


HTML:
<hr>
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
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>
^



~-~
