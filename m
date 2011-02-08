Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1BHRrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:47:33 -0500
Received: from seamus.madduck.net ([213.203.238.82]:50360 "EHLO
	seamus.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab1BHRrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:47:31 -0500
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Feb 2011 12:47:31 EST
Date: Tue, 8 Feb 2011 18:09:16 +0100
From: martin f krafft <madduck@madduck.net>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Opteron ECC/ChipKill error
Message-ID: <20110208170916.GB26278@fishbowl.rw.madduck.net>
Mail-Followup-To: Borislav Petkov <bp@amd64.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20110208133010.GA26487@albatross.oerlikon.madduck.net>
 <20110208134910.GA3849@kryptos.osrc.amd.com>
 <20110208135956.GA7055@albatross.oerlikon.madduck.net>
 <20110208142442.GA30263@aftab>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <20110208142442.GA30263@aftab>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux 6.0 kernel 2.6.37-trunk-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Borislav Petkov <bp@amd64.org> [2011.02.08.1524 +0100]:
> Yeah, well, keep your fingers crossed. Just to reiterate, getting ECCs
> is not a problem per se - they may appear even during normal operation
> and in this case get corrected just fine by the memory controller.

That's what I thought. Many thanks for confirming it.

> > Don't want to spam the list, so:
> > http://scratch.madduck.net/__tmp__dmesg.gz
>=20
> Ah ok, this is a .32 kernel and it doesn't have the information I was
> looking for. I've changed that in later kernels so that EDAC dumps the
> DRAM chip selects placement on the memory controller.

Excellent to see you are working to improve this. If the problems
increase, then I shall either turn on CONFIG_EDAC_DEBUG or upgrade
to 2.6.38.

Thank you for your help!

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
wind catches lily,
scattering petals to the ground.
segmentation fault.
=20
spamtraps: madduck.bogus@madduck.net

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQLvBAEBCgDZBQJNUXi7wBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xPWD
D/480XZsYooPxleapbNr9Fjf70vqy7+kFPCAFrNXfvdD0jZeeioYUo6fgPiLzMnb
bA6RpzfSekFHBFjvxLi4Rc+abDyufmn6sIAOXgxAg1vNuB1IrAdcZFtJ95Tm84Yy
HCdDLPdKSQxlk/Amw/NCm6LEEoRvXvIcRxCN43T8xeLy35oQbM3ux5QQowlqgpRj
o/s2ZrOKRFmFCbycRB2ElwLCRsbtgfJhxnY49i5mB8CghADNJkU7IZJOaPnFW9Us
B4C29/XF7qeZ3k2T7/cCJVBng1kR1iK4Us9ksYbD3LhZihBc7UHpOVDmjbUiMfus
Nqbls5IaNiE2qWbZrj05LjkicZD2DGbwjgR44fr9GmklHKI9HNnSsaw1IF+9nazb
K/v1Wuk3hOmFs7CI8t7zL26EALBkJQKbo1NxiZvAJmsm6FymPIHqAjCRbXcCaOlc
lmPwxluawpKGVvllSgpaoZ6T9ZNwemVvfcbFd31k9NhhdA1Pq1XX8C8s/nGfm5iU
s5lKKMEN05PIgcp4++K10jw0id4yRfvCLREmChDfvX2RK2e9vhcQdALtUE8q4/J7
ep/3ORGpidDmmOSGotVC1koG3vVZTjXEx65zlMP4lJ6rN7SCHEqmdUnKWuPem+ab
tBPULYfZWecdg1x3L0oQDOu+0lXKVoNkmlLOujwFeOSeaA==
=zdZ2
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--

