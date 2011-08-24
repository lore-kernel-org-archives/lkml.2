Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab1HXIvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:51:20 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:48237 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756628Ab1HXIvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:51:18 -0400
Date: Wed, 24 Aug 2011 11:51:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: balbi@ti.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        akpm <akpm@linux-foundation.org>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH -next v2] usb: fix dwc3 build when USB_GADGET_DWC3 is not
 enabled
Message-ID: <20110824085113.GC12549@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110823160432.d24f8cad00951286bc18461e@canb.auug.org.au>
 <20110823110702.f5ea377c.rdunlap@xenotime.net>
 <20110823185235.GA11299@legolas.emea.dhcp.ti.com>
 <20110823125247.fbbf9636.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ZLFUWh1odzi/v6L"
Content-Disposition: inline
In-Reply-To: <20110823125247.fbbf9636.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ZLFUWh1odzi/v6L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 23, 2011 at 12:52:47PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> Fix build error when CONFIG_USB_GADGET_DWC3 is not enabled:
>=20
> ERROR: "dwc3_send_gadget_ep_cmd" [drivers/usb/dwc3/dwc3.ko] undefined!
>=20
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks Randy

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--4ZLFUWh1odzi/v6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVLuBAAoJEAv8Txj19kN1LLAH/0PAiAm4OYhVrSddeA8pGVAl
2jqb6fCMTHPqfXsYJs5NJc76SL6sOSFNNwzNk6+vowuIb06VsVewVwXA8UPvJr5O
qs3mLL9b5QoIilbGdsIGDtAWmZAzQtXO/CGsffpc/Zn8q3ecBHVMNlDcwzbQIkYW
DiEV9zR//ZxeXqY6gW7KX/FGAi45f3RxIXcD242wzudO6k020YOAvqpyBkqCNOnq
5zLBuvO/RQMMCnaPIcE7VIJNnvEHAN84d5WH5pr2OTrkix5GphRbM3/8rydLdCua
RCCsBdKzFd7IO3ghO/8MPLw/OXQz4ZNcrwPUp1KilwSuaLkL+mRWVFaQ18Vo0ZM=
=mAhB
-----END PGP SIGNATURE-----

--4ZLFUWh1odzi/v6L--
