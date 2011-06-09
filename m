Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1FIJoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:44:10 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33155 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660Ab1FIJoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:44:08 -0400
Date: Thu, 9 Jun 2011 12:44:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v15 2/10] usb: Configure endpoint according to
 gadget speed.
Message-ID: <20110609094401.GC13552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
 <1307360469-29120-2-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uHXdqxJKu4m6W3Gg"
Content-Disposition: inline
In-Reply-To: <1307360469-29120-2-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uHXdqxJKu4m6W3Gg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 02:40:46PM +0300, Tatyana Brokhman wrote:
> Add config_ep_by_speed() to configure the endpoint according to the gadget
> speed. Using this function will spare the FDs from handling the endpoint
> chosen descriptor.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

applied to gadget branch, thanks

--=20
balbi

--uHXdqxJKu4m6W3Gg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8JXhAAoJEAv8Txj19kN17FoIAIHu2cRNkVZ6od63Uf8AHc4n
3eXc3P5gXmrd6fC2Ah7MkQgZptpab5w8JNaX0BjSfhsAU6ZBmpiYLvDJbxFPdcj1
1O8pEl5AbtAYi5SL/0UQON7BPKgEcVz0F2fCIM35IZh0qOhOu7G4fCxgF2dxpJv+
EhWctYoPo5Ynjx4v/DRDDtkpuxReNW34eep2brK7NEWB6DUPGlrx9rA3BMwDTacl
ouYTlJ74jc2Tac1yHjBtjha83lg8L8ga234A44y+3zN/5HSdSt5OLuMav3rWD95B
6vxcfiN/UIHFo0qBpoux3c+B0Ygq173mF561+YTU7Lez7FRu2C2+mBuA20xjulM=
=NAeG
-----END PGP SIGNATURE-----

--uHXdqxJKu4m6W3Gg--
