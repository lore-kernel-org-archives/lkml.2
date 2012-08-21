Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2HUKYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:24:47 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33460 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123Ab2HUKYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:24:45 -0400
Date: Tue, 21 Aug 2012 13:20:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [RFC/PATCH 05/13] serial: omap: drop DMA support
Message-ID: <20120821102045.GL10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345540555-24359-6-git-send-email-balbi@ti.com>
 <CAMQu2gw93ES=u9J1FfWK_CKkgUq8V487+tmKtQ34p8O7VJ6aHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1EIGrW/+75u5Nmw"
Content-Disposition: inline
In-Reply-To: <CAMQu2gw93ES=u9J1FfWK_CKkgUq8V487+tmKtQ34p8O7VJ6aHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L1EIGrW/+75u5Nmw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 03:14:19PM +0530, Shilimkar, Santosh wrote:
> On Tue, Aug 21, 2012 at 2:45 PM, Felipe Balbi <balbi@ti.com> wrote:
> > The current support is known to be broken and
> > a later patch will come re-adding it using
> > dma engine API.
> >
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> Thanks Felipe !!

no problem.

> One less driver now towards OMAP DMA
> engine conversion.

indeed :-) I'll take a closer look into rx timeout IRQ, but it looks
like we can use it to kick dma only for "big" transfers... need to play
with it for a while first, though.

> FWIW,
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

is this Ack for this patch only or the entire series ??

--=20
balbi

--L1EIGrW/+75u5Nmw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM2D9AAoJEIaOsuA1yqRE8KAP/2i8rFk1bFTBjZgONPFW/J6a
3sWWHuK6WOnwohLJkDhiKkFlXTIlEW8jMhSu1xyRpQnDWo+c9Z1pL9hzze2SrmGp
yEQGPZw7c03cDAiH7shMkjPuTZeow+wHl8B1nCsGJNgtDwbVESvj95+yktUcmn9h
pdI0nd99s5jo/DCtPp3+EdAnN9Uj0REV9pvTCV27IDnuncHiY8QiCAQnmtwyW6sw
PftX1NGY/Wbv8tSLDXFvnmTq3Ln4EfceA5PCJHadmZ/5KrKOhsu3L15MluQhw9pm
bx6S91NTgiZiLcj8iUp9WOTqI+aUbVPfWP++G8duTSczQyElxQy0hQm9rHi13ief
RnshZNXhdAMHhzCzx6pOEn5EggatWYgNoosNOgFVgd2KSr9BG8PWwCjUtL4T16s3
9/HRjlTocE9BSWvBSZ2viSep52WgYFqYzSREmgc4GKHkz6BY7Wn+fZSuTcx5jZyW
2qO61Qpf2O9KWNLz06pkqpkdN2E3FzvhwBglg8kRw/4wGmSQluvrtC2PbEWzgQkj
dlDIyTCxctBXUMp2yvpH5jrDGv019FC3xfdSjM1M516i83LddyG03fifB54lIraH
6OrRCOlxBDhXWxbJqfSHffwU3FJLYB7FK+1XK3T6nhiAOX3xInWHTYCfjyWEEuj6
2JIFEUCXmMPakW6Vr6a2
=TOAs
-----END PGP SIGNATURE-----

--L1EIGrW/+75u5Nmw--
