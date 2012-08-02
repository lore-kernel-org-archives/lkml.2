Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab2HBGSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:18:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2HBGSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:18:52 -0400
Date: Thu, 2 Aug 2012 08:18:37 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
Message-ID: <20120802061837.GF12241@avionic-0098.adnet.avionic-design.de>
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com>
 <20120730074714.GC15245@avionic-0098.mockup.avionic-design.de>
 <50185619.5090706@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBnjLfzoMQYIXCvq"
Content-Disposition: inline
In-Reply-To: <50185619.5090706@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:EylA/qwu8D3RyNnWPVM4xE/juoaK/fPfTisqP1g7rpl
 JKhdascnKsnnyayBr57BxPvQyfQ18pQasNscRc5PAEfvH42nes
 kf+EVcc57cPUqz3DSWBbNRH6iFHarq/l56+osy6lJQLpj7AsSb
 Koy8WDojP+wW9z9unGYNK2GdcFeJGrZ+UntW7Vl7qGOMHsUEeD
 U1OjvxvUV30ZhCcurZSRC5geqxmHF0eYoypszRtcBVBxTHBYDI
 TJEXdfG9MK5NALBKj38AKiGUWLqGVD3Gs4EbxA2sqU2TJfEdOx
 Eb8HAA7Ym933q75SUg77EaI5W/P3qdRfpxqEEGpPuRpBPmd7xc
 5cqlIzi+ThYhiDVZ1DHISrOfbQMAToTKaKrQ9OruHdM0b59pd/
 qYBdx8reMHdch9m8Ermw2KW8reGkBaJsCPAgHaE+/s5Pv6WuiQ
 ocQIs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UBnjLfzoMQYIXCvq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 31, 2012 at 05:03:05PM -0500, Rob Herring wrote:
> For nr-gpios, I think it is typically not needed. Generally, you will
> know how many gpio lines the h/w has based on the compatible string. If
> this part really is the same part but different packages with different
> numbers of gpio, then this property makes sense.

That's exactly what I need it for. The controller is synthesized in a
CPLD, so technically the part is always the same, but the configured
logic can implement any number of GPIOs.

Thierry

--UBnjLfzoMQYIXCvq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGhu9AAoJEN0jrNd/PrOh0LQP/2JbP2YRXQEUzZh4YO05baQv
Qx1X+4/cORFs4jYYPvu4YBtonZST9fvQpWNAP+aMMb38hBXnAlOCreejlNrmq3/U
a+d6aCtWkqkbtpbvwLJLwRUAUuRHw21zXlGCRGbjhWHzunl3eHcCSRaMSZs46EkM
GlBQKWOf6YeDNne7KqUMqqI0G+7bFVZVW29SZqkiVaSFIPH6dIGUZwDR/uXLp34n
wNV3aere2Dqvffj7xQ6S9j/8Sw1W0/H6MokDkieK/lQMXJgV5Vhc/TTpiOohyCxR
L2aaogKRzLXG7wp/uvEmCK+VVw0W9rixj/Zv4wMiRXcoZBDbyimX49tEDYM6dkT9
Hb+bhKOTTaZcfcFhSThL4yUdtjaKerdxs99K5OPAL6/OzwmtlgKleCgBGXr/15gD
n5mjgRjePDyorJK/T+i5VuYjV6u+XPrOx7CweFMR4I8JrwEewOszND/Eb9uQ1H75
bphaG8G3sTUAe0O6ekClxSQiNL7UUxmAjQ3tKjPZXI5e6+CqBKRKd0ajysNNdBvZ
mUO5Fkkr6FHQuxOaB3gDLke9GZoEsJAOmanAhfV0/lO5M9Svw+q9UvprZbPsnTle
5N5DZTVJgXri5E5A1xEHtxT1btNQpREIWEEJuYrA5AcjWcWwNdMdI2nh/WKVfQZk
tg1bcGBby6Xao7Oteh8k
=5LWR
-----END PGP SIGNATURE-----

--UBnjLfzoMQYIXCvq--
