Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1EWGTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 02:19:25 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:47678 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab1EWGTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 02:19:23 -0400
Date: Mon, 23 May 2011 09:19:11 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, balbi@ti.com, ablay@codeaurora.org,
        linux-arm-msm@vger.kernel.org,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 4/7] usb:gadget: Add SuperSpeed support to the Gadget
 Framework
Message-ID: <20110523061909.GE3095@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305805417-31750-1-git-send-email-tlinder@codeaurora.org>
 <1305805417-31750-5-git-send-email-tlinder@codeaurora.org>
 <20110520164924.GC31929@linutronix.de>
 <002401cc1850$c4cd7030$4e685090$@org>
 <20110522105908.GA26607@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cYtjc4pxslFTELvY"
Content-Disposition: inline
In-Reply-To: <20110522105908.GA26607@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cYtjc4pxslFTELvY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, May 22, 2011 at 12:59:08PM +0200, Sebastian Andrzej Siewior wrote:
> >Well here is the dilemma: if I do it the other tree were done - I get
> >checkpatch error.=20
> >You're right, adding this the way it's above doesn't look too good but w=
hen
> >I fixed the other three I was asked not to do so in this patch, which al=
so
> >makes sense since it has nothing to do with SS support...
> >So what do I do? Submit with a checkpatch error?
>=20
> It is nice to have things consistent and a follow-up patch could fix the
> checkpatch error(s).

I tend to like more when the cleanup comes beforehand ;-)

--=20
balbi

--cYtjc4pxslFTELvY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2fxcAAoJEAv8Txj19kN1lEUIAKMpq0ThJ7Av6jrsMteB2aGH
wJ2JK5HFfZ6qdXVuOIrVPZRY2w4s7ON7jtQNBIoIk8xa2pVW+LRpv83O06wFHCiu
bbn8Ist3ZT4hz2T7032qNREFGka4sFJTrjAIGxiehM1VkfsypbZVW4a/3cPnO4Zx
DdJBlJk/Kdnpqecv8T2clFlm0TCgO49Ymcs5FbsXAu5Sy3za/pH3Y/rhSxv7bttY
/LwWTsXoQvgu6aAX+FU/ITPr0UhsFKbA1M+/Gu2gEY3eBZjgnasOf/SUlG1qk7Rk
0J7v4RApe8jNMTHtNmx6Wlqxr3zxdASDWcd+qAbpRa2tYsYLMZTYgYLlNjQv85k=
=BCk9
-----END PGP SIGNATURE-----

--cYtjc4pxslFTELvY--
