Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2HUME5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:04:57 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:37722 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163Ab2HUMEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:04:53 -0400
Date: Tue, 21 Aug 2012 15:00:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Poddar, Sourav" <sourav.poddar@ti.com>
Cc: balbi@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [RFC/PATCH 4/4] gpio: smscece: Add support for gpio IO expander
 feature
Message-ID: <20120821120052.GD10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-5-git-send-email-sourav.poddar@ti.com>
 <20120821105333.GW10347@arwen.pp.htv.fi>
 <CAKdam56DiFpnoQwrHe1tjQWLMy5vP9ynstNj_n=OyMxkJJAUOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e3HNah56eoWqGn2Q"
Content-Disposition: inline
In-Reply-To: <CAKdam56DiFpnoQwrHe1tjQWLMy5vP9ynstNj_n=OyMxkJJAUOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e3HNah56eoWqGn2Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 21, 2012 at 05:17:37PM +0530, Poddar, Sourav wrote:
> >> +     if (type & IRQ_TYPE_LEVEL_HIGH)
> >> +             sg->int_lvl[bank] |=3D bit;
> >> +     else if (type & IRQ_TYPE_LEVEL_LOW)
> >> +             sg->int_lvl[bank] &=3D ~bit;
> >> +     else
> >> +             return -EINVAL;
> >
> > this looks wrong. You could have a user who wants to trigger on both
> > HIGH and LOW levels, no ?
> >
> Yes, I think there can be a scenario where gpio_keys are attached
> to this driver and signals a "key press" at low and "key release" at
> high. ?
>  Will figure out a way to add support to check for case where
> both High and low levels are used.

could probably be done on a separate patch, maybe... Just now I saw that
HIGH and LOW levels use the same bit.

--=20
balbi

--e3HNah56eoWqGn2Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM3h0AAoJEIaOsuA1yqREVsEP/128t7kFxIyPtzzivHuOliqu
fiBqNyB7VSAbkOxpsAeG7QNxjAhWdvWeIwBLRk+4PdTra5f6XRIxCDJVTvXaPaqC
/m5TH0ELfzVSTFhilboOFmppazg036Nb+rlfHiEz+DOVJOmTokMFwWOptBVg6KRQ
ClGhXL4E7PzSAGxxq3XhFFe3uQ09RT6ZliAuwMH6LsnFg01HnYS1vC83Q+zaC8dg
kgmRIupGeuANI596RTrn6W9qqBDl2ee728MuwFhg2uY9CVpIqQQT4w3NeVIh4eVl
/DvQpFuN3nl+FchZn6EXIRzSRliuJKXegnD08Geh2J61l62u3Dry3unE5C/sRkmR
QUPcXfyL/omMoww/Sir2ztmbqvK7st/bEMXEdFnHDNI4SQpnauRT0I5QelV2N+NW
YV9yxn3D7W9kIprKtGoTCgD1vYQUMxgCfQdqdq5Qb/MDMqd3qdrS5HNyXtuCb0PG
P/e5wPH3BKY41OaF/kBwBr7fesoMKFvajPxlWob8xH2tdVhrTnxXGm1omapdMfpM
AH77XTRUR+R54FLb4rzbFWO3pHU6V5oe5+qQuOsD+CzcK+XgLFQObAcuCs1UaJ93
8Ri/BNolwB54iU9SUAW51qUkZjFqnjQ4/zZnxFJl4noBNoCILUy92WN8BoNCScQv
o237Yirp2EgphuxxnF46
=Jvvq
-----END PGP SIGNATURE-----

--e3HNah56eoWqGn2Q--
