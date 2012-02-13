Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2BMNIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 08:08:41 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:57708 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab2BMNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 08:08:39 -0500
Date: Mon, 13 Feb 2012 15:08:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "open list:DESIGNWARE USB3 D..." <linux-omap@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:AMD GEODE CS5536..." <linux-geode@lists.infradead.org>
Subject: Re: [PATCH 0/9] usb: gadget: generic map/unmap routines
Message-ID: <20120213130832.GV6614@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1327405543-27589-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j2Klb18PAKd8hQ5U"
Content-Disposition: inline
In-Reply-To: <1327405543-27589-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j2Klb18PAKd8hQ5U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 24, 2012 at 01:45:21PM +0200, Felipe Balbi wrote:
> Hi all,
>=20
> here's a rebased version of generic map/unmap patchset.
>=20
> Also available on generic-map-unmap branch of my tree, some
> of the patches have been tested before and already have a
> Tested-by tag.
>=20
> Felipe Balbi (9):
>   usb: gadget: add generic map/unmap request utilities
>   usb: dwc3: gadget: use generic map/unmap routines
>   usb: gadget: langwell: use generic map/unmap functions
>   usb: renesas: gadget: use generic map/unmap routines
>   usb: gadget: amd5536: use generic map/unmap routines
>   usb: gadget: r8a66597: use generic map/unmap routines
>   usb: gadget: net2272: use generic map/umap routines
>   usb: gadget: net2280: use generic map/unmap routines
>   usb: gadget: goku: use generic map/unmap routines

Tomorrow, will complete 3 weeks since I re-sent these patches. Since
nobody has had any issues with them, I'm considering people are happy,
so I'll queued them up for v3.4 merge window.

--=20
balbi

--j2Klb18PAKd8hQ5U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOQtQAAoJEIaOsuA1yqRERpkQAIREfhgrtL2brIWZI0KB1h2F
Y4lU5r4O1nFSKxo+NOuJYsXZPw4ZobjBLNumT+rFSvwKeq+DJZpZfxQ259CKGDHD
B/Ki++c81WbPud0y9a5iUHi27wtQkpRivyrgUgte1tl7VRtrLQOu/X6oUDcxh8yj
eKJnibNp1ms7kKvpxuHVhnkjDF1SeE7f85QRgl06Q5Z23kgsLfqBcPt343egUX2h
vMpDz26pN3nQl3tR9tOa5YIhT+6fmUITq4FMTRK3jQvdIjyu4PrsBR50mepGiYub
Nz1D6/wGIYs+hwnvofSrT9SRPMRvHRq/Nh2nAAZHlTLKRQHMKMuzzWQ/eLxFfhCG
F7tZ61GzzHunmeFg8+q0SqMY7eeysLJ22kpAB3gvKB3KyFdaUTzhrd4YEG4dtfX7
EoYrY4r1ZAf4DZYddziXpKccapxVk7AAY6xBlkvNlDKwG+78IzFiW5uezs/cJD1a
0z8inijFrNjDJzRQrvXZSkyelfNXmUyk/F0eo8PJzz+kNiXVqM4H+lGdVjBUTmEU
QV3DnZr6kMkkEW5dXfd7k1Uy/J0Rcz673R4IDb0UmLrXRQdc6uKKEYX8UE6SiLj9
LLDJ8i2FC2ZIwaMEHKX7DtzoL7+ElJ5DUcfwBNyyOrtYUYLVmEN9/qqW+atrp3Rb
ozTqNqR/3HvyhSQUSvjN
=GsJT
-----END PGP SIGNATURE-----

--j2Klb18PAKd8hQ5U--
