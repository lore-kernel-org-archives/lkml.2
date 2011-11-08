Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab1KHOCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:02:50 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:45386 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab1KHOCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:02:49 -0500
Date: Tue, 8 Nov 2011 16:02:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/2] USB-renesas: move to dma_transfer_direction
Message-ID: <20111108140241.GU6921@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
 <1318610350-23335-2-git-send-email-vinod.koul@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3/Wm4stOzDzLYPbq"
Content-Disposition: inline
In-Reply-To: <1318610350-23335-2-git-send-email-vinod.koul@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3/Wm4stOzDzLYPbq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14, 2011 at 10:09:10PM +0530, Vinod Koul wrote:
> fixup usage of dma direction by introducing dma_transfer_direction,
> this patch moves usb/renesas driver to use new enum
>=20
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

applied, thanks

--=20
balbi

--3/Wm4stOzDzLYPbq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuTaBAAoJEIaOsuA1yqREqfoQAJZyjdLdlKS1rRajDBovt/W3
cCGG03w9bmqk4XLnPN+uwliT99hjMC/mEqErSOX0LShC+obJqHkx2gWfAHZyTii2
VRVc6XrMmt5Sn6NaTNRGODoLiPuQTB4j22kDmP+EENbKhlnulF2gcUT+XnvLPr1D
AnyN/OF9Ocg20HVv6MBKlOPfquLAyxHf/at6QYxaeGlnbn1kc4L0hhbhWVJKVA5/
K/d6daNFNtxR76QEARomUfkOWQaS9gWMnfXhvf2am9LmgFALEVwxQUAcaSUl3+Nl
LZF89eJwA9eug70PhXncyyFm281MDRbfT+TLJIF9xTexUopbGZ4y2gMvqm0HM9kB
PkPTr76xNAn9k+UzQUvzjBXeMvpeU1NOwrkfCp1qxKckmn6HkcMe8C/KaWYuuE4G
1/R0cLYWbQDSSUxJtGuhU6rGXQMPWphg7MHYI5tx0GXgr3ana0Cq4MlKufb4/pBT
bCrw+jgB7aYjX3UfbO/A5fXDkvTncEjtlONEtdNY4XmY4kt9smKEbGzL9KTXNqxx
fOjJ/1TEnJ0NZ0khFI7YevsEeVY/saizR7RJzPGWGxgcDRblNRaYP/tcSLCPlvMm
R8+dNYjPnzqYkZWP0CbL8RQS4IlDfv/VvOcNlVGd7TGadmwvP6XbD/vfCTwtL4pP
8mNSYc0aF70CdsO+9cFe
=ytRX
-----END PGP SIGNATURE-----

--3/Wm4stOzDzLYPbq--
