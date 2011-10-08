Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1JHAg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 20:36:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49325 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab1JHAgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 20:36:25 -0400
MIME-Version: 1.0
In-Reply-To: <20111007181826.GA20210@merkur.ravnborg.org>
References: <CAO3ZPq18MfYTu_6_RLZvvB0_0aFwTR3AfzKbKMRp5Bzt62Frnw@mail.gmail.com>
	<CAO3ZPq2RUjW7VQQSoN-S7QDuTYdCMuDfoykHSeXwr19MTnCb_A@mail.gmail.com>
	<20111007181826.GA20210@merkur.ravnborg.org>
Date: Fri, 7 Oct 2011 17:36:22 -0700
Message-ID: <CAO3ZPq0JU7854=AYR9a8SRcacUn1=7BhfCP=s93SJFTtmpuGSQ@mail.gmail.com>
Subject: Re: MODULE_LICENSE("GPL") not working for me
From: Stephen Williams <steveicarus@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0ce0f5984c0bf604aebebff7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0ce0f5984c0bf604aebebff7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I've attached the Makefile as I have it so far, and I've also attached the
output from make ... V=3D2. The Makefile is a canonical multi-object-file
module makefile, with some extra trappings for version stamping
and my source code management.

When I look at the object files, NONE of the generated *.o files contains
a .modinfo section, even though there are MODULE_LICENSE("GPL");
lines in the linux.c source file.

Incidentally, the source files in the ../libvidforio directory are generic,
so do not include any kernel header files.

On Fri, Oct 7, 2011 at 11:18 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Fri, Oct 07, 2011 at 10:20:46AM -0700, Stephen Williams wrote:
>> On Thu, Oct 6, 2011 at 3:30 PM, Stephen Williams <steveicarus@gmail.com>=
 wrote:
>> > I have some large drivers for use in embedded arm systems, and
>> > I want them to be GPL, because I want to use some symbols exported
>> > as GPL, and also because I just wanna. But it is not working for
>> > me. I've attached my Makefile. I'm building from outside the kernel
>> > tree, but that should be OK. (right?) I'm using the following script t=
o
>> > actually build:
>>
>> More information: I can see that the vidfor.o object file, indeed
>> none of my *.o files, have a .modinfo section. In other situations
>> where the licens stamp works, the .modinfo section is present.
>> I'm using the CodeSourcery build of the arm toolchain, and in
>> the simple cases (module that is a single source file) the
>> modinfo information works. Hmm...
>
> I lost the original mail...
> Could you try to post the output of make V=3D2 when you build your module
> and the Makefile fragment again.
>
> =A0 =A0 =A0 =A0Sam
>



--=20
Steve Williams=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "The woods are lovely, dark a=
nd deep.
steve at icarus.com=A0 =A0 =A0 =A0 =A0=A0 But I have promises to keep,
http://www.icarus.com=A0 =A0 =A0 =A0=A0 and lines to code before I sleep,
http://www.picturel.com=A0 =A0 =A0=A0 And lines to code before I sleep."

--000e0ce0f5984c0bf604aebebff7
Content-Type: application/octet-stream; name="make.out"
Content-Disposition: attachment; filename="make.out"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gthvdk9k0

bWFrZSAtQyAuLi9saWJ2aWRmb3JpbyB2ZXJzaW9uCm1ha2VbMV06IEVudGVyaW5nIGRpcmVjdG9y
eSBgL2hvbWUvdS93aW5nL3N0ZXZlL3BpY3R1cmVsL1NFMC92aWRmb3IvbGlidmlkZm9yaW8nCm1h
a2VbMV06IExlYXZpbmcgZGlyZWN0b3J5IGAvaG9tZS91L3dpbmcvc3RldmUvcGljdHVyZWwvU0Uw
L3ZpZGZvci9saWJ2aWRmb3JpbycKbWFrZSB2ZXJzaW9uCm1ha2VbMV06IEVudGVyaW5nIGRpcmVj
dG9yeSBgL2hvbWUvdS93aW5nL3N0ZXZlL3BpY3R1cmVsL1NFMC92aWRmb3Ivc3lzJwptYWtlWzFd
OiBMZWF2aW5nIGRpcmVjdG9yeSBgL2hvbWUvdS93aW5nL3N0ZXZlL3BpY3R1cmVsL1NFMC92aWRm
b3Ivc3lzJwptYWtlIC1DIC9ob21lL3Uvd2luZy9zdGV2ZS9waWN0dXJlbC9TRTAvbGludXgtMi42
LjMzLXF1YXRybyBNPS9ob21lL3Uvd2luZy9zdGV2ZS9waWN0dXJlbC9TRTAvdmlkZm9yL3N5cyBt
b2R1bGVzCm1ha2VbMV06IEVudGVyaW5nIGRpcmVjdG9yeSBgL2hvbWUvdS93aW5nL3N0ZXZlL3Bp
Y3R1cmVsL1NFMC9saW51eC0yLjYuMzMtcXVhdHJvJwogIENDIFtNXSAgL2hvbWUvdS93aW5nL3N0
ZXZlL3BpY3R1cmVsL1NFMC92aWRmb3Ivc3lzL2xpbnV4Lm8gLSBkdWUgdG8gdGFyZ2V0IG1pc3Np
bmcKICBDQyBbTV0gIC9ob21lL3Uvd2luZy9zdGV2ZS9waWN0dXJlbC9TRTAvdmlkZm9yL3N5cy9v
cHMubyAtIGR1ZSB0byB0YXJnZXQgbWlzc2luZwogIENDIFtNXSAgL2hvbWUvdS93aW5nL3N0ZXZl
L3BpY3R1cmVsL1NFMC92aWRmb3Ivc3lzL2NvbnNvbGUubyAtIGR1ZSB0byB0YXJnZXQgbWlzc2lu
ZwogIENDIFtNXSAgL2hvbWUvdS93aW5nL3N0ZXZlL3BpY3R1cmVsL1NFMC92aWRmb3Ivc3lzL3N5
c2ZzLm8gLSBkdWUgdG8gdGFyZ2V0IG1pc3NpbmcKICBDQyBbTV0gIC9ob21lL3Uvd2luZy9zdGV2
ZS9waWN0dXJlbC9TRTAvdmlkZm9yL3N5cy9pZGVudF90YWJsZXMubyAtIGR1ZSB0byB0YXJnZXQg
bWlzc2luZwogIENDIFtNXSAgL2hvbWUvdS93aW5nL3N0ZXZlL3BpY3R1cmVsL1NFMC92aWRmb3Iv
c3lzLy4uL2xpYnZpZGZvcmlvL3ZpZGZvcmlvLm8gLSBkdWUgdG8gdGFyZ2V0IG1pc3NpbmcKICBD
QyBbTV0gIC9ob21lL3Uvd2luZy9zdGV2ZS9waWN0dXJlbC9TRTAvdmlkZm9yL3N5cy8uLi9saWJ2
aWRmb3Jpby9pbml0Lm8gLSBkdWUgdG8gdGFyZ2V0IG1pc3NpbmcKICBDQyBbTV0gIC9ob21lL3Uv
d2luZy9zdGV2ZS9waWN0dXJlbC9TRTAvdmlkZm9yL3N5cy8uLi9saWJ2aWRmb3Jpby9mb3JtYXQu
byAtIGR1ZSB0byB0YXJnZXQgbWlzc2luZwogIENDIFtNXSAgL2hvbWUvdS93aW5nL3N0ZXZlL3Bp
Y3R1cmVsL1NFMC92aWRmb3Ivc3lzLy4uL2xpYnZpZGZvcmlvL3ZpZGVvLm8gLSBkdWUgdG8gdGFy
Z2V0IG1pc3NpbmcKICBDQyBbTV0gIC9ob21lL3Uvd2luZy9zdGV2ZS9waWN0dXJlbC9TRTAvdmlk
Zm9yL3N5cy8uLi9saWJ2aWRmb3Jpby9jYXB0dXJlLm8gLSBkdWUgdG8gdGFyZ2V0IG1pc3NpbmcK
ICBDQyBbTV0gIC9ob21lL3Uvd2luZy9zdGV2ZS9waWN0dXJlbC9TRTAvdmlkZm9yL3N5cy8uLi9s
aWJ2aWRmb3Jpby9pc3IubyAtIGR1ZSB0byB0YXJnZXQgbWlzc2luZwogIENDIFtNXSAgL2hvbWUv
dS93aW5nL3N0ZXZlL3BpY3R1cmVsL1NFMC92aWRmb3Ivc3lzLy4uL2xpYnZpZGZvcmlvL3ZlcnNp
b24ubyAtIGR1ZSB0byB0YXJnZXQgbWlzc2luZwogIExEIFtNXSAgL2hvbWUvdS93aW5nL3N0ZXZl
L3BpY3R1cmVsL1NFMC92aWRmb3Ivc3lzL3ZpZGZvci5vIC0gZHVlIHRvIHRhcmdldCBtaXNzaW5n
CiAgQnVpbGRpbmcgbW9kdWxlcywgc3RhZ2UgMi4KICBNT0RQT1NUIDEgbW9kdWxlcyAtIGR1ZSB0
byB0YXJnZXQgaXMgUEhPTlkKICBDQyAgICAgIC9ob21lL3Uvd2luZy9zdGV2ZS9waWN0dXJlbC9T
RTAvdmlkZm9yL3N5cy92aWRmb3IubW9kLm8gLSBkdWUgdG8gdGFyZ2V0IG1pc3NpbmcKICBMRCBb
TV0gIC9ob21lL3Uvd2luZy9zdGV2ZS9waWN0dXJlbC9TRTAvdmlkZm9yL3N5cy92aWRmb3Iua28g
LSBkdWUgdG86IC9ob21lL3Uvd2luZy9zdGV2ZS9waWN0dXJlbC9TRTAvdmlkZm9yL3N5cy92aWRm
b3IubyAvaG9tZS91L3dpbmcvc3RldmUvcGljdHVyZWwvU0UwL3ZpZGZvci9zeXMvdmlkZm9yLm1v
ZC5vCm1ha2VbMV06IExlYXZpbmcgZGlyZWN0b3J5IGAvaG9tZS91L3dpbmcvc3RldmUvcGljdHVy
ZWwvU0UwL2xpbnV4LTIuNi4zMy1xdWF0cm8nCg==
--000e0ce0f5984c0bf604aebebff7
Content-Type: application/octet-stream; name=Makefile
Content-Disposition: attachment; filename=Makefile
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gthvdsle1

CgpEUlZPQkogOj0gbGludXgubyBvcHMubyBjb25zb2xlLm8gc3lzZnMubyBpZGVudF90YWJsZXMu
bwpMSUJPQkogOj0gdmlkZm9yaW8ubyBpbml0Lm8gZm9ybWF0Lm8gdmlkZW8ubyBjYXB0dXJlLm8g
aXNyLm8gdmVyc2lvbi5vCgppZm5lcSAoJChLRVJORUxSRUxFQVNFKSwpCgpFWFRSQV9DRkxBR1Mg
Kz0gLUkkKE0pLy4uL2xpYnZpZGZvcmlvIC1JJChNKS8uLi8uLi9kZXZlbC9pbmNsdWRlCm9iai1t
ICs9IHZpZGZvci5vCnZpZGZvci1vYmpzIDo9ICQoRFJWT0JKKSAkKHBhdHN1YnN0ICUsLi4vbGli
dmlkZm9yaW8vJSwkKExJQk9CSikpCgplbHNlCgpLRVJORUxESVIgPz0gL2xpYi9tb2R1bGVzLyQo
c2hlbGwgdW5hbWUgLXIpL2J1aWxkClBXRCA6PSAkKHNoZWxsIHB3ZCkKCnZlcnNpb24gaWRlbnRf
dGFibGVzLmM6CglAZWNobyAnIC8qIE1BQ0hJTkUgR0VORVJBVEVEIC0tIERPIE5PVCBFRElUICov
JyA+IHRtcC5jCglAZWNobyAnY29uc3QgY2hhciB2aWRmb3JfYnVpbGRfc3RhbXBbXSA9JyA+PiB0
bXAuYwoJQGVjaG8gJyInYGdpdCBkZXNjcmliZSAtLXRhZ3MgLS1sb25nIC0tYWx3YXlzIC0tbWF0
Y2ggc3lzLVwqYCciOycgPj4gdG1wLmMKCUBkaWZmIHRtcC5jIGlkZW50X3RhYmxlcy5jID4gL2Rl
di9udWxsIDI+JjEgfHwgKGVjaG8gInVwZGF0aW5nIGlkZW50X3RhYmxlcy5jIjsgY3AgdG1wLmMg
aWRlbnRfdGFibGVzLmMpCglAcm0gLWYgdG1wLmMKCm1vZHVsZXM6CgkkKE1BS0UpIC1DIC4uL2xp
YnZpZGZvcmlvIHZlcnNpb24KCSQoTUFLRSkgdmVyc2lvbgoJJChNQUtFKSAtQyAkKEtFUk5FTERJ
UikgTT0kKFBXRCkgbW9kdWxlcwoKbW9kdWxlc19pbnN0YWxsOgoJJChNQUtFKSAtQyAkKEtFUk5F
TERJUikgTT0kKFBXRCkgbW9kdWxlc19pbnN0YWxsCgpjbGVhbjoKCSQoTUFLRSkgLUMgJChLRVJO
RUxESVIpIE09JChQV0QpIGNsZWFuCgplbmRpZgo=
--000e0ce0f5984c0bf604aebebff7--
