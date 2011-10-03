Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1JCKHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:07:19 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:38846 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755040Ab1JCKHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:07:10 -0400
Date: Mon, 3 Oct 2011 13:07:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 15/30] usb/musb: use a Kconfig choice to pick the right
 DMA method
Message-ID: <20111003100704.GD3363@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1546914.88vcgxkfJf@wuerfel>
 <20111002221050.GA25790@legolas.emea.dhcp.ti.com>
 <3529819.LQllWhb43D@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <3529819.LQllWhb43D@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 03, 2011 at 11:40:26AM +0200, Arnd Bergmann wrote:
> On Monday 03 October 2011 01:10:51 Felipe Balbi wrote:
> > Anyway, I'll take your patches in, but their too late for this merge
> > window  I already sent my last pull to Greg.
>=20
> No problem. I need the full set of arm-randconfig patches upstream in ord=
er
> to make randconfig work in general, and that's not happening for 3.2
> anyway. Right now, I'm just trying to as many patches as possible into
> maintainer trees.
>=20
> Is your tree part of linux-next, or will it only show up after the merge
> window once Greg has pulled your first set for 3.3?

My tree isn't in linux-next yet so my patches go to Greg and from there
to -next.

--=20
balbi

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOiYlIAAoJEAv8Txj19kN1CDYH/2+3/wYhWXA7fHPdfefo6QDu
mL/EPGzv2Ub7oZ3qjQ48oEYaCUGwqsahjK0DNGtVKaE/y/Hv4twF3WXvK7VqKvMB
0mhiiVp6Sx5/GafgZbmRnc8xEG0gvkb+n63eETlsmbITYJM5sB88WA83QpJOYJ7r
LGAfYDGVZ/SMe1sKco/LC1xgyxlP7+Vrb+OVs+os+An2PaaRaTvfHkPDokoKARDl
CsyMDeWuPoEaihRAuHIkq40KIp4634YfTa/pV7xtu0+ghy1tEyISizQVG5X7cwVC
O+dwHLsIgX4KUbS/WFQsyUPHHNARWRtKD1SvOmp9rpEFCp7lGeKp65W8tm+VzNc=
=2pOE
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
