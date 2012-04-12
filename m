Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761775Ab2DLL0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:26:43 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:45035 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754188Ab2DLL0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:26:42 -0400
Date: Thu, 12 Apr 2012 14:25:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>, Michal Nazarewicz <mpn@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_mass_storage: remove deprecated fsg_add()
Message-ID: <20120412112547.GL25224@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1ad5f25435fc5d2cd094ae1c68d7831b8b2737ca.1331896818.git.mina86@mina86.com>
 <op.wcndcuqd3l0zgt@mpn-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vTfKKTivj/mQoluA"
Content-Disposition: inline
In-Reply-To: <op.wcndcuqd3l0zgt@mpn-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vTfKKTivj/mQoluA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 12, 2012 at 12:13:32PM +0200, Michal Nazarewicz wrote:
> On Fri, 16 Mar 2012 12:21:15 +0100, Michal Nazarewicz <mpn@google.com> wr=
ote:
> >From: Michal Nazarewicz <mina86@mina86.com>
> >
> >There are no in-tree fsg_add() users and it has been deprecated
> >since 2.6.35 [1dc90985d1: fsg_add() renamed to fsg_bind_config()] so
> >out-of-tree users had more then enough time to convert.  Removing.
>=20
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

thanks

--=20
balbi

--vTfKKTivj/mQoluA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPhru7AAoJEIaOsuA1yqREJjIQAJ81mbbYdCfjtcXVV3zdNUFc
aLgG2F+dY1G1y2rKU5mJsNt7mRHVrokX53ZVsbgA+GV2TVD96N60d3ReROfd/h/b
WiEPCB1WIuenIstEn/eZboUs+IJN9FQSwhwHun/l45ynJScree5YYvLGq23VaT9B
jl3iXwuynpZDPnTyiGCgrfQrVnSeae99+dNmS2WJ1QOgeU3MmlDeC3G+yOtum6YA
wxlYfWNPC9is5t09LtVgeOYJ6XRDTiAd0frlY2lB6ZSVgu1AvxYrrw6QsxC3Xqce
VGjNVVLA55hDdZe+fyHfcaSUwNTfoSW5YUAvnj92T8WppNlIjpu5q78laa10/GyM
eQTV4l9+ajX5lr1axJd1/Pw+18IhY1HY8fudOLYWI8BMEWrFXmWdvjKi1aV3KgZJ
pX8fhFhZ0h2VjGFs40bSN6fRVNOMpbMnuOlN9Bbh8XBWdQLEJJkuLELv0lAxC/F9
evTAT0wgsAEAItNzoCye7Lr2WSqyQsqxqtbl5WtKFuUgz/WGJglNx+AQFrN0P49P
qap6WeWlhfMIXmi5XmGpZyPd9Dxo9g+F/mem51b1UosGMdWxC8pUQC6NYXRYg9ir
uMu6sI/dKsaFu4ybyp0CgH4+BmismKVqzY7As5TQIWSIJ8eJGAACfQC+H9VHneGk
CdzRS7woX+UbH/HuqTNv
=5922
-----END PGP SIGNATURE-----

--vTfKKTivj/mQoluA--
