Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2IMGsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:48:23 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:52607 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755976Ab2IMGsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:48:14 -0400
Message-ID: <1347518888.7471.38.camel@lappyti>
Subject: Re: [PATCH v6 0/4] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Thu, 13 Sep 2012 09:48:08 +0300
In-Reply-To: <1749811.4qrG1GZfBf@percival>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
	 <1347515447.7471.12.camel@lappyti> <1749811.4qrG1GZfBf@percival>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fAdGNzRhttcXPFVhUejd"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fAdGNzRhttcXPFVhUejd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 15:23 +0900, Alex Courbot wrote:

> DT support is actually the main point of power sequences, as outside of t=
he DT=20
> we can always work the old way and use callbacks. If we were to remove DT=
=20
> support, I am not sure this work would still be worth being merged.

Ah, I guess you meant hooks in the driver, not hooks to board files?
Yes, that would work, but if all the hooks do essentially the same
things with just minor modifications like sleep-time, it makes more
sense to have just one piece of code which gets the sequence as data.

 Tomi


--=-fAdGNzRhttcXPFVhUejd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQUYGoAAoJEPo9qoy8lh71l38P/3+BcNUPNUVaUMSBT8HhxKR4
StxDb/+IIhZUkkauxkGOflFlQdp7oQtkoV28/5+R5khDzbUNCA2shDCLGq22xg3o
SN44j9UbySCjwbqwLnhCph2B4g+dvVLilS6bYieQaL2oCJAoJVJ54UKLC+DMmGdj
J+vlHx+byyWEq57/EY7Nk8/qMMHVYRLV+yaSz5vct+AEmQIDNEou6yQHYOEtUml/
juK/KIE6dR41NEwc/+nhchao5PwUlhdiVGCImtqJS+9h1xLxtFbNYti6fcnxgryK
1HSBK+jbTVGB09+zwqGiX4/hXGTr3L1ASXGBgMFjq8/I9UQU4u4PJ4RZ2ZhPxxyS
DFRljioAQbyys5RMwyjqIAvwid3yd3g786WEeSphggB/tUxKRm7HObcaclhgdeEL
D7N1/UUrbSUPSgNTVndXAW09IQfr4vpAg/V4gUQkRRqDlhkMR5xYHli1DH2L0M8g
Lgx//ha90WgTCpxRinl+NzUzuByM4L+m75Ud73NntU1Vpgn4PQak5jcdsWkokVfo
yqioF32iHq4r1i1aI8o8sjFaqYzqLjNGGVc6jVwtJdm1UysyGjy8beRJ59oHWq+r
C8zxeAmb+IH1/V/uXN366y2KXXsAv8BpO/istze+M4kXMeXxVZBDRXj0aSlqbJiO
vnWS0FGfYFh47qrNdiwJ
=vBoM
-----END PGP SIGNATURE-----

--=-fAdGNzRhttcXPFVhUejd--

