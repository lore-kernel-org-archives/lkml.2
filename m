Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab1CBVtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:49:31 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47957 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab1CBVta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:49:30 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Garrett Cooper <yanegomi@gmail.com>
Subject: Re: [ANNOUNCE] The Linux Test Project has been released for FEBRUARY 2011.
Date: Wed, 2 Mar 2011 16:49:26 -0500
User-Agent: KMail/1.13.6 (Linux/2.6.37; KDE/4.6.0; x86_64; ; )
Cc: subrata@linux.vnet.ibm.com, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
        Shubham Goyal <shubham@linux.vnet.ibm.com>, ltp-list@lists.sf.net,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, chrubis@suse.cz
References: <4D6E2C9C.1060404@linux.vnet.ibm.com> <1299068635.4463.1.camel@subratamodak.linux.ibm.com> <AANLkTim+pyy=Dr7-kMrSiG=5RHqY2L6P01m9hH171D8G@mail.gmail.com>
In-Reply-To: <AANLkTim+pyy=Dr7-kMrSiG=5RHqY2L6P01m9hH171D8G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5050038.7jGgyvo2Tm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103021649.28430.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5050038.7jGgyvo2Tm
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday, March 02, 2011 14:45:38 Garrett Cooper wrote:
> On Wed, Mar 2, 2011 at 4:23 AM, Subrata Modak
>=20
> <subrata@linux.vnet.ibm.com> wrote:
> > On Wed, 2011-03-02 at 13:06 +0100, Paolo Ciarrocchi wrote:
> >> On Wed, Mar 2, 2011 at 12:40 PM, Shubham Goyal
> >>=20
> >> <shubham@linux.vnet.ibm.com> wrote:
> >> > Hi,
> >> >=20
> >> > The Linux Test Project test suite has been released for the month of
> >> > FEBRUARY 2011. Please see ltp/INSTALL file carefully, as there has
> >> > been multiple changes for building/installing the test suite after t=
he
> >> > recent changes in Makefile infrastructure.
> >>=20
> >> Wouldn't make sense to integrate this test suite in the kernel source
> >> tree?
> >=20
> > There was discussion like this some few years back. The idea was to get
> > some core tests from LTP to the kernel source tree. But then the idea
> > was dropped probably to avoid maintenance overhead ;-)
>=20
> Putting LTP in the kernel.org sources really doesn't make sense for
> the following reasons:
>=20
> 1. LTP isn't really tied to a single kernel release.
> 2. LTP isn't the only test project out there for Linux.
> 3. LTP has more stuff than it needs to have for testing out the kernel
> (well, it did more in the past before I started cleaning it up in the
> past couple of months).
> 4. Maintaining it will become a political bloodbath for both parties
> as Linux is loosely managed by Linus et all, and LTP has been largely
> developed by SGI and maintained by IBM and a few other parties like
> Fujitsu, Nokia, Redhat, etc.
> 5. Integrating LTP into Kbuild, etc would probably be non-trivial due
> to the size of LTP (but it might be easier after the Makefile
> restructuring I did a year and a half ago).

these are all very good reasons.  additional points:
 - ltp is pretty fsckin huge
 - ltp often times tests both sides of the userspace API/ABI -- between the=
=20
kernel and the C library, and the C library and end applications
=2Dmike

--nextPart5050038.7jGgyvo2Tm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNbrtoAAoJEEFjO5/oN/WBsMsQAKQsRlsrxsz3f0Fwcf1712KJ
pHma1HyNNh5uZhQ8bSeqHhrn2YVGLq6KhNRyr5PaPZcV9MO4c+ylD1opiVPbqNyR
/Kk/grDxUQY4UStAbi6C4Cw/XGR7ImoF6XICq5a3gunm/DnJ9r48fRLV+a/qSen+
YCMzhN+yNAJimmsVIcFpKBSOsaQCAdxEBNAplReDolNS3sxgU3AN6Lz012D5wHqt
c1c2pa5IW/ds0w2z9FxzdQGuu/7nKZqcr0bzrpF7qJCJ4z8d6/qNTiQlKZhjKaD+
Ieebc6DZa0JCObvhOoOXHtOV+ILHvQ3k2z3X/m41LC5wyS8MRWoP0bRsYlQNVMqr
FgTO+lI8WEDMPZprVelRXTHzZFk20VWczeETMP+XEThbSl0Zh2nlsT9nXq/jp7p5
9feaIXnW0YhMR2uxE5ZvhguGj5L27wlCtHwmSGu9S3yx7FlQWDNMLODtaAkKDarO
mAvj5QDGbaT23+aPAVjJJwOfbS/vUSfOiD+d8VEtsi1Hv63qnuF9l7TeNoWrpAJO
zHKZjfK2OR3lcMAHEs3OSxiyRn1++2bFei47cRnGFdItF0LlLLZQ0gdR4d9MHgHB
AsVrZX19Wu/eeVm7cnGy0m3Xbp1cnMHNPN3sgF27SbDOZEEr11PKMKfRuELYh4mg
ptvkqlLQDMYKw4J/1QLZ
=SvnO
-----END PGP SIGNATURE-----

--nextPart5050038.7jGgyvo2Tm--
