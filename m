Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab2KIUUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:20:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62282 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2KIUUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:20:30 -0500
Date: Fri, 9 Nov 2012 21:20:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Christian =?utf-8?B?S8O2bmln?= <deathsimple@vodafone.de>,
        linux-tegra@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/2] drm: tegra: Add HDMI support
Message-ID: <20121109202023.GA8615@avionic-0098.mockup.avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
 <1352469579-3337-3-git-send-email-thierry.reding@avionic-design.de>
 <CACna6rycZ=TGHP7KpVa_r0JSpc6c=PB89pijR9E_4A=bQ=74Bw@mail.gmail.com>
 <509D28B6.3060207@vodafone.de>
 <CACna6rxOBENLVC8mgJdsSdAZdWranMiivSgq_8DzeTo0hzzWqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <CACna6rxOBENLVC8mgJdsSdAZdWranMiivSgq_8DzeTo0hzzWqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:9D/YFpgQ4fblIbzs9k3wd5MRn9Xu7XbOki5nxspGF99
 GwtNRqTAWa/T00AQcPN4AKJncOABfHZ8pmBTQxfLzM/XKRgPZy
 qCDTxxSaeAYG5fQk1m8DmYTlWjxLSGJq1m4WZ7HrS+i9IlX5F/
 77mPYqIntlffWuKlGd0uHYieqNXCZdktzK5+e3rW2kkWe+9nC2
 Y9nVjj/xt2TkgdSUiLzDh+NOXyxtQDkRvxRW7QFNs3oNZB/60X
 lHD+hgjTMlEbcMnvSu8osacKWxji322yc0DWEUfextegm0RKh3
 R6ieTo/+iD0QIqdNTlFTMfRlMSw4cTTef1rheuntCVNR95pmeG
 eZtSNnhpmeN3GMBoRZEQbMw9j67P2VwQUzCNrbnNT+Uiuw9OEo
 S9R4ozXg5rUAsV7ETfMt28Ys0huslWUAV4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 05:04:09PM +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
> 2012/11/9 Christian K=C3=B6nig <deathsimple@vodafone.de>:
> > On 09.11.2012 16:45, Rafa=C5=82 Mi=C5=82ecki wrote:
> >> I was told it won't work on different endian devices. See
> >> [RFC][PATCH] drm/radeon/hdmi: define struct for AVI infoframe
> >> http://lists.freedesktop.org/archives/dri-devel/2012-May/022544.html
> >
> >
> > Yeah, that's indeed true. And honestly adding just another implementati=
on of
> > the HDMI info frames sounds like somebody should finally sit down and
> > implement it in a common drm_hdmi.c
>=20
> Agree.

Any volunteers? If nobody else steps up I'm willing to put some work
into this. I'm a bit reluctant to do this right away since time is
already very short before the 3.8 merge window. If I promise to look at
this once the Tegra DRM driver is in, would people be willing to let it
slip for now?

I know this is not much of an argument and I'm all in favour of a
generic implementation, but I don't think endianess will be an issue in
the near future on Tegra. I don't believe there are any plans to make it
support big endian.

Thierry

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnWWHAAoJEN0jrNd/PrOhhJEP/22zbfzbluQbEVe6B9IPz8QB
WpIOLuKKcm/5T89hDR9hical47cSmOhAHFY08NBCSDyli7tCdduNOozqixTjFspC
rPLiK6kdHgmTCkhunt5QS/VohfiomAgNwcQjJaRPr5CKdMvsCqIIzNxdHLirwC2/
QNs3rDPjRjSp/r4+iQKwR5eSm+SML7CGJQ65cyS/vFrEe15LmGJAPCyI/rEajM+o
xYxMOUcpZ9wZAk6HM8waDxgoh25zgFFqpKnb55ao1IyRZAGl9zhydAB9SNuLTaYm
jncKn11FZjKU442AP8XWydTDflVRaRjhp79xd7xro5No38hoI32tuHqIZ44xSDGZ
F+jVHbYA/uhLkYgUUis2DSJBkpO+8Aci29RmNre47gIj3Wj2NY1LBWbVPz3HUnfS
IadxSb2iI5iIroM16fw2V83J1ntNnXhaySiIEbj7sxn/cHCLjUMSazAmTP+jUHlz
Aq3jhxCX+KLdnxqCIFBu1abTRFsFEPNidjN7PnoZpE8ZEoERkSnD18khVAKv/7Cr
txcAOY4vPFqWPe7FEb529KnWw4s1d4rM/MQHqJ/8ZCIUO8950+A+2E/chYKa5sRV
4dnRh3wbkEOvERTOG9wxrnZP+9BdaWNHZbhGzrN/bd8NuLsebw6m1Km7+cLyh3Ve
7o0rgBPQ+WIRuBDgX0ka
=uTGI
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
