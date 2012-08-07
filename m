Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2HGMZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:25:12 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:38888 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379Ab2HGMZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:25:10 -0400
Date: Tue, 7 Aug 2012 15:21:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Shubhrajyoti <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: In case of dma errors fall back to pio
Message-ID: <20120807122125.GY8468@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343197229-15188-1-git-send-email-shubhrajyoti@ti.com>
 <20120807074740.GR11011@atomide.com>
 <5020FA2C.2020707@ti.com>
 <20120807120227.GA11011@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rmLdANEyqdgxlbgR"
Content-Disposition: inline
In-Reply-To: <20120807120227.GA11011@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rmLdANEyqdgxlbgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 07, 2012 at 05:02:27AM -0700, Tony Lindgren wrote:
> * Shubhrajyoti <shubhrajyoti@ti.com> [120807 04:21]:
> > On Tuesday 07 August 2012 01:17 PM, Tony Lindgren wrote:
> > >>  };
> > > Don't you need to check separately for rx and tx dma? There's a slight
> > > chance that you get a channel for one but not for the other..
> > In that case I treat it as non usable and fall back to pio.
>=20
> OK that should work too.
> =20
> > Are you suggesting that let one channel be dma and only the failed one =
pio?
>=20
> I guess both are doable. For reduced CPU load using DMA where possible
> of course is the best way to go.

indeed. if you can get DMA for TX but not for RX, then at least TX can
go via DMA ;-)

--=20
balbi

--rmLdANEyqdgxlbgR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQIQhFAAoJEIaOsuA1yqRE4zQP/2vYamY7tzdA8q5oSdbs2KZy
GHXKOobLMBVB18EnKyL4oSJy69q5kDkdDPpldknLoFzoTh7+ihuyMzUmtU1CY5th
ML7tYMgb1/PS4oxBctg3SGr3ZnsINp8q0Iv4p8QQuQPdqP5hp2WZJAiaaTwTFvAN
aX1OSeKsd1cr7WSW37Jb4/c3vWa4zoiLzoTNpxePXKlc6ahQ1/JZqZf7WQK3WW10
smh6bMR362P+BEV0LmNmEBDmrM3j7wSInwCieGlSn5mm7a0sADKVTWjhvKS2xlv1
/6KlPaH1LgPNPNj10tMFJgsY2tyRjDyXUI76pQiUtz2kmvC3jAGn6ASaOZxSr6f9
pDZJnSp1qC8HSzK0R5j3Hu9zuy9xIKeZnRE105r91kidpsmmjshzBwiAIpp+DOPS
27hVw5/MzoNs2Y2k+AFwzncUi8eKjQCZsU6Bun30NP8q6PoHhHLZ8gVGTPtPi3pn
z+aeWAttbQqIUlvBGvWvVDr/8PrGI6L0dSuqifpcoJxnSiWCQoMnZmj9Yr99xhJx
cSX44rJiTXCNwpxsPkyiNnvv7L7JbQKkVdV+LvaW78lDAfz2SkIUnxlHrnHCEz1/
+Ugl9AD0nVhbLkg2s9LeVp1p83PZ1uudCuvP1XvjLvLgqOz5MxAYlj6y0EMfEZ8i
dAt0NOOXy/pigCP01w2J
=TGT8
-----END PGP SIGNATURE-----

--rmLdANEyqdgxlbgR--
