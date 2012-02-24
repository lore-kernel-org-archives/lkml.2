Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2BXWff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:35:35 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:38302 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754248Ab2BXWfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:35:34 -0500
Date: Fri, 24 Feb 2012 14:35:30 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] PCI: Add class support in quirk handling
Message-ID: <20120224143530.14459752@jbarnes-desktop>
In-Reply-To: <1330069619-14446-2-git-send-email-yinghai@kernel.org>
References: <1330069619-14446-1-git-send-email-yinghai@kernel.org>
	<1330069619-14446-2-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/myL8qmXQ3v77_Fybr464V/J"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/myL8qmXQ3v77_Fybr464V/J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2012 23:46:49 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Recently there is new support to make quirk calling will report duration =
time.
> That will boot log get more print out with initcall_debug is specified.
>=20
> Found a lot of quirks are calling for not related devices.
>=20
> Reason is quirk frame do not support class handling. So quirk code have to
> use PCI_ANY_ID for vendor/device and let quirk code itself to check class
> inside the func.
>=20
> The patch add class and cls_shift into struct pci_fixup.
> Also update related macro to accept the class and shift.
>=20
> -v2: fix v1 that left over of sparated patch.
> -v3: according to Jesse, change cls to class, cls_shift, to class_shift.
>=20

Applied these, thanks Yinghai.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/myL8qmXQ3v77_Fybr464V/J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPSBCyAAoJEIEoDkX4Qk9hG6MP/RWmLp0cCVL40gE9KDsDwJH8
3Ab+CGivGkeDFpBwDN3eyNPT94qHxgwVObpohxi+QPtUjpEKIKafglNbdYyRVa9O
xxnc6+F12dTzxWnEWmU7R2VZmcI4RGTeUGxoRFoTvlGv2oEcIS08aCJEoco/XlrE
e7CTWX+A9ZrUuXXtqZhY06R+JcKhOmAm392WmgMhqDllY5xXLdtNv+L08QZ9zaqh
rRHW/RrWSuhNrcVFUUBVwRkxML5SFkjVCvgfxZ1GupC1Tv+Kq4HWO5piWs3gY2d4
Y96ij7eDzMR7lhwUODRzYfPP1bUGwohbGSJEAra9b8rcCGCmwxPHuQ+AjyHjuv2u
zg6qEHuDN++RQEOjPA9hcwRyr+ZUyb9ibSAuDz0q46DAknhpCsOtXd5SQ3BPFxNj
oSfct+pnDvQbiwHbr+gfL/b0jNFBZWcHJFy6snqH3bP06MyHWAu7s9z8cHKBVltQ
n5atbugxgILrHazo0s+PauaH2UtLVLMGEbeS0h8ZGszpxllKnwg5a5PfVTC9Vjm2
cJZ5OtNsa5rudfi9lOuje33GaDcb+oe1Uc7SOlEPHPsCp7M78EyoleCjRi+t1p+F
xT0GnoyrSLktPhAEi7uVbMkTcYMlUy6zHQuI5IAG4ETJJrz/5H4XEzWj04gd7XrO
xGfq4TB1jn7qTDNS+q97
=yHzM
-----END PGP SIGNATURE-----

--Sig_/myL8qmXQ3v77_Fybr464V/J--
