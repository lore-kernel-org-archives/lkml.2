Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab2KMIDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:03:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2KMIDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:03:36 -0500
Date: Tue, 13 Nov 2012 09:03:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Dave Airlie <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] drm: Add NVIDIA Tegra20 support
Message-ID: <20121113080323.GA15983@avionic-0098.mockup.avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
 <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
 <50A1FE01.5090808@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <50A1FE01.5090808@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:NE7hOJ49BeHHj/fzge6Vjc3kzgefncaw5ukMJQn9Wia
 OIydkXaYylHp4hw6ID6uqfAnQmIuDnkjI1yxY9wr/rW63ntAqe
 X/U1klZD7jn2psSdzDQDScP5Etz4M5x7g9yTednwzaJ6Fmz70N
 P0oQx9q4sNBI6cyQ7C2xTWh+/YnWcqAdQOSAQSzAdj03hca084
 HTDuXr5LUFRVnsxCByZKMVGIcmQHUsQEcfcKw5M34gSbXhLNzl
 t0AYQHiTfQrJRyYDdQhnMfan9TrurTE7fMMcgcRpkKBEDZASJs
 XfBQ0/BsfV2JO8Qaomj7JLESqOW218RsqOB+dwEKt2kpNlN74O
 Oo9Y9aQmSDP204VHioxONHM0zPQlPKsdYHW+pQ5la7JyT38/Be
 jD2DJxH00n0itmhfISn84Wqg66ZrEHGyFEeCRP2disqgPkilPd
 HQypo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 10:00:01AM +0200, Terje Bergstr=C3=B6m wrote:
> On 09.11.2012 15:59, Thierry Reding wrote:
> > This commit adds a KMS driver for the Tegra20 SoC. This includes basic
> > support for host1x and the two display controllers found on the Tegra20
> > SoC. Each display controller can drive a separate RGB/LVDS output.
>=20
> Thanks Thierry for the hard work. I noticed the same thing Stephen
> noticed earlier - I couldn't compile the driver.

That should be fixed with v2 I posted a few hours ago.

> Other than that, there were a couple of differences to the tree we've
> worked with and tested earlier: Tegra30 support was dropped and as a
> consequence so was IOMMU support.

Yes, Tegra30 support will follow in a separate patch. As for IOMMU
support it should eventually be made completely transparent, but I'm not
opposed to adding a patch with explicit IOMMU support back in if it
turns out that it can't be done transparently.

Thierry

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQof7LAAoJEN0jrNd/PrOh+o0QAI4CvF/E1oupG1YU04DopqIN
LmZJZqGzCFIwFM24mmYhoVYlGXwUnyJ6Rfycy76XXkkgSmtaICGCUD5vadIC+k1Z
TNb8RPPf7OoZ/E5i+YKQAoaSt62Ao9XXVJ8tAyi1WAN61O2U1S9utdCnbaQQRRrc
Bh7PRsoM1PeC/o04FH1v90Xs3hLz+TVsC8BXxTQsTK/IrH3pLPoPlAZSOIc86d1d
qKxpTwe53uZezPymsQ1BAF4NkqYzLpjga3pgAo+o/EwwZ5qGs4SXe1aC97cYFEj4
4ULjBoOaXvViVTrp4Q/6VfVcrD505LegRYdXZ7J2AaW3IDVl31ep2eVTjLeb6KWA
iTu23Exe7ADDebhEIVCBfexwZwD/LcssKs7KqRbswEgMtZ9ncIpN6Z037NkfNHJz
cRi3FCkfQF5JY3mcLXixB9+3QHo2t8ngZqelKKj6WCIGREdgKRKxW//eB3cdAvYC
GJzVFqUOeObP+pKVqBg8Bgc6oU6icfAKREIvUb1oIa2ncNCpUvPc+1zZBnBgrFD9
TH5f+31jMj5ASViRix2VuT9WNwtTDt9u2o+Ko7hhHde8UQYXBO6U0OXyTkI/xeqs
pS06l8MlBln5uHEdKRQBOKtgs5FElJ4BnbShd2XWEtHq/VCN+FyhIOeP8WrlKWAu
6bCcWdEepG45ScA/1GFl
=0OEH
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
