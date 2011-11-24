Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1KXLgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:36:06 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:46317 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab1KXLgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:36:04 -0500
Date: Thu, 24 Nov 2011 13:36:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: gadget: replace usb_gadget::is_dualspeed with
 max_speed
Message-ID: <20111124113558.GG3352@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
 <e484c31d52744be95bc87f36561e5b1e5d6c2af9.1321719300.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r4jNezHNW2wfBox+"
Content-Disposition: inline
In-Reply-To: <e484c31d52744be95bc87f36561e5b1e5d6c2af9.1321719300.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r4jNezHNW2wfBox+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Nov 19, 2011 at 06:27:37PM +0100, Michal Nazarewicz wrote:
> This commit replaces usb_gadget's is_dualspeed field with
> a max_speed field.
>=20
> [ balbi@ti.com : Fixed DWC3 driver ]
>=20
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

applied, thanks

--=20
balbi

--r4jNezHNW2wfBox+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOziweAAoJEIaOsuA1yqREea4P/jmGPkDrXnZaruXGh+zfywv7
8vBaCsclGNOKeiV7MSbSg/osB9aZFtsGqgv1+VaMA8FCFIx7EJ7/HJDVQ58nD61H
PY8U64hoQh5IU658IETdf3Flp82sRnVR2liTKGB9AVgKOZifz3zLct7rFWariJI1
Uk4mcxvdUR0oZL4fazE0VbMSYpJxAxQP/5LErC/YrVzCpVHCEUZt5V2TLFU7rdCG
4m3Lc88ZSP5sLANKQGb0HTXtC/sn5eU67SerIs0d/LfBlp3XV1ECoNO3lX7ANUuo
EfFCX7h26zFeWqUraEKAkSDor1c9INnnu+2lZ+eFrU85iJR0oTTkgDxHEG1EAvuA
L6W7SZnd3+fs7+513Jc8wUPR88ZreRqdpMdsHQ9POzxGZHQizxi9YuMENL3VPq1A
gOjs3VK5OKWyw46P6qgTLnMgNdpUO3VzNFUjPeo3YPDyAorZQP+npfYZactMLXIh
0Cty85SsHhFzcO7g+yPmJAATSyjKjmcLRo8mYPNhx0rY5NNFWNu3eNrJurlWAu6U
hv3YdllLRha5Mt0ODbdR/blLhXtaGeQcV1+dqG73sorD277J2plmvCurs2KS2uqa
eNbBVYSsRb6ATnE3q3qUxocfrVZ+b0VPXcRNBR32162nooI77Bl7Y2acTmdxy9lA
q1K/3WXwkdhzo8N+7Ing
=SbyI
-----END PGP SIGNATURE-----

--r4jNezHNW2wfBox+--
