Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2DKJLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:11:37 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:54811 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753475Ab2DKJLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:11:35 -0400
Date: Wed, 11 Apr 2012 12:10:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Felipe Balbi <balbi@ti.com>, Xiaochen Shen <xiaochen.shen@intel.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: use module_pci_driver
Message-ID: <20120411091044.GE12064@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1333548898.5856.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cYtjc4pxslFTELvY"
Content-Disposition: inline
In-Reply-To: <1333548898.5856.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cYtjc4pxslFTELvY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2012 at 10:14:58PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/usb/gadget/* to use
> module_pci_driver() macro which makes the code smaller and a bit simpler.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Xiaochen Shen <xiaochen.shen@intel.com>
> Cc: Pavankumar Kondeti <pkondeti@codeaurora.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

applied, thanks

--=20
balbi

--cYtjc4pxslFTELvY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPhUqUAAoJEIaOsuA1yqREB80P/2MzBdVQzsP0zei+/Wa5ROKh
e3N7SrDbnyEggwrYu+FNz9uEj10Mir6hLDg+5uHGgz62IcwBOR6JK1L7KofFzhjm
5IQJkRm0qHefUR6ybTYNNEpPeVSX/nmlQ8RzomCg/6sep5x6ed+Ka2Xqp3U79rKE
KQMAyzqg/7v3eNeOgIZy0e/obtloXwUrCXh2hsZnnR6kKGYXxFCzzFKzM7suWWiZ
4fH9YQu0mrYzkBkvrw3hm18h5c6/wJI934MXy5UMgXyVqpfb9a10Rh/Bkd2sFGrJ
BS3xAwfR+HrWEDUjvoZycA8IwjwfT2SXclXDeGyvJlnhjH5LNU1aOxfQi7UFI9CQ
O22mk9V9FkmCa4SX5hqydxRsC/aOcOvig5nYkm2Ijv1u/e82QZ2DtZEiVXbsheYp
1hHPemKQF1ensBbh4G+B8UUll2gKPQLbPFX3udS8em0ozoXWL++qfsPhKwm5J+OV
PSv9pi6zQffwxzVT4bJANSFkV5EbH6UK0MVmeHkj4JezE42gSA1TjRfkJnB+TlNr
8T1lVOkH9B/To6GRSp4vm4fbKBCZgSUdX5F7fLFW+Rbv3SgeapAZyDFr0PGb79ZY
W1VNS7EJMGotYrMKAcXED2jkhWkYM2wH4UhhV6KymBIqX+7iiZFqNtJKZ/BS8bBL
mKyvDk5g7rOZowwVdlqZ
=xQxH
-----END PGP SIGNATURE-----

--cYtjc4pxslFTELvY--
