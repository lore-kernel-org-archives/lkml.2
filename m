Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab1LWVbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:31:09 -0500
Received: from home.keithp.com ([63.227.221.253]:32919 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab1LWVbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:31:08 -0500
From: Keith Packard <keithp@keithp.com>
To: Udo Steinberg <udo@hypervisor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: GPU hung with Linux-3.2-rc6
In-Reply-To: <20111222014520.7ace1ab2@x220.fritz.box>
References: <20111221195410.5e4c065a@x220.fritz.box> <864nwty9sq.fsf@sumi.keithp.com> <20111221222626.0b8c3a30@x220.fritz.box> <861urxy1pw.fsf@sumi.keithp.com> <20111222014520.7ace1ab2@x220.fritz.box>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 23 Dec 2011 13:32:17 -0800
Message-ID: <86k45nnfdq.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


It would also be nice to know if disabling VT-d in the BIOS resolves
this issue, or if building the kernel with IOMMU support and then
forcibly disabling it with 'intel_iommu=3Doff' fixes the problem. Given
that you can easily reproduce this, it would be good to know how your
machine differs from dozens of others which work fine with semaphores
turned on...

Oh, and the output of 'lspci -nn -vv' would be nice to see in case
you've got older (or newer) chips...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTvTzYTYtFsjWk68qAQiaPhAAlWoTEuViaOCqmX8XtMPoXUjy9oDPhHnS
W8WkhzPeq3CJS8SclHNQDCipEKcJzZVjw1tkdKicuRWnpZRtS9aPJxD/bYDc4KaF
Deu2zy8AJWJNkpuDjm9Lc8if3VC2rNCqNRSYadKlLelS0+XPZUk1/CRWn0Hlsoxs
lyZPaTFd2dOJWXVs3uog47Oka6rwaPreheJ9xOHbTITe0+dSolQl8gxTrlg1/N42
P8B1TgnriFCFg6LUGw3MsR5PzCdnuvfPrP8qKd5Jtx153y6ayxDwTjLDcrb/mBSd
WtbTm4Cgh9dX151pk+EmGiTDU48gbH+qdbC+NTdy6dfDNSWXLhm/0WliHFrid7Pt
Yyl7VYi3Mxcq2Surlc6ej9X6FNwRdAjFNGfFGOT1MeBx6izQEmtboCp33ugKp8Wj
XR71y21ddKmraZfi/QTW+cpeKX6Fzu/ybTviXCpahMiETOWQSXCWzUoenUkmbmtB
KBHnqtMzBMckN1RIuGgUL/KUkoAP5VZY9CIIpCIHCCxJ9OjLI6t2WVT1m8CNw3fZ
Pj/UYhF4Qjorvs9wisY0S4vs4YHd2efeH/ae8PJYVbse8Y4swrIf/0bRoJx6rKRg
tcAq60SqMIXW3PfGJx32CuB/pHqpePa6Ed6FoP9pLxUcknD4IRv24kG8EOwWiIEN
ynRSd/jzlJk=
=iPXN
-----END PGP SIGNATURE-----
--=-=-=--
