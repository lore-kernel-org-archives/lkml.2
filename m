Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2KUJto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:49:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42531 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2KUJtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:49:42 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ed-50aca3b4b691
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1353451739-6317-1-git-send-email-dianders@chromium.org>
 <20121121072959.GK7615@quad.lixom.net>
In-reply-to: <20121121072959.GK7615@quad.lixom.net>
Subject: RE: [PATCH] ARM: exynos: add UART3 to DEBUG_LL ports
Date: Wed, 21 Nov 2012 18:49:40 +0900
Message-id: <0dff01cdc7cd$86b14500$9413cf00$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HugXfkbz1xHkASa6yplqc72iJcgAE3OkQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zQ90ti9cEGBxbamRxedccNosZ5/cx
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJVxp4ulYCdXxeYL09gbGOdxdDFyckgImEhsX7eIGcIW
	k7hwbz1bFyMXh5DAMkaJplmbmGCK/m5ZD2YLCSxilNh5PxPC/ssosfE1D4jNJqAhcfj9M3YQ
	W0TAT2JD5wYWkEHMAi8ZJV7+ucoO0ZArMXnaBrBtnALGEqcauhhBbGEBW4mpq2eDxVkEVCV2
	fZrOAmLzAsVPrjvNCmELSvyYfA8sziygJbF+53EmCFteYvOat0C9HECHqks8+qsLYooIGEnM
	eSkCUSEise/FO0aI6QIS3yYfYoGolpXYdIAZ5EoJgVXsEkuvf2KFeFdS4uCKGywTGCVmIVk8
	C8niWUgWz0KyYgEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2MkPiS3sG4qsHiEKMAB6MS
	D6/EvtUBQqyJZcWVuYcYJTiYlUR4N01ZEyDEm5JYWZValB9fVJqTWnyI0Qfo8onMUqLJ+cDY
	zyuJNzQ2NjEzMTUxtzQ1N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBsTvc3HfBkmVr
	Q3/qTf2t/P/XMkVhhS1rBf4HFnN9D7t1bvq95Um6RvP/XOLK+16wb/5+A1eLZQJyl/f4lzcu
	PLH19leL3mPxDRf6lf49n3zkRundmUoiTonb5NfHSWk9yPm8mUla9tS0+P3KFZxZuz6E6a+4
	sM47xflXT9qSoMnOqr/65kTIvFZiKc5INNRiLipOBADzh2Fc3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jAd0ti9cEGLx7q2dxedccNosZ5/cx
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcaeLpWAnV8Xm
	C9PYGxjncXQxcnJICJhI/N2yngnCFpO4cG89G4gtJLCIUWLn/UwI+y+jxMbXPCA2m4CGxOH3
	z9hBbBEBP4kNnRtYuhi5OJgFXjJKvPxzlR2iIVdi8rQNzCA2p4CxxKmGLkYQW1jAVmLq6tlg
	cRYBVYldn6azgNi8QPGT606zQtiCEj8m3wOLMwtoSazfeZwJwpaX2LzmLVAvB9Ch6hKP/uqC
	mCICRhJzXopAVIhI7HvxjnECo9AsJINmIRk0C8mgWUhaFjCyrGIUTS1ILihOSs810itOzC0u
	zUvXS87P3cQIjt5n0jsYVzVYHGIU4GBU4uGV2Lc6QIg1say4MvcQowQHs5II76YpawKEeFMS
	K6tSi/Lji0pzUosPMfoA/TmRWUo0OR+YWPJK4g2NTcyMLI3MLIxMzM1xCCuJ8zZ7pAQICaQn
	lqRmp6YWpBbBjGPi4JRqYNR+PaXkWen8aVt+zzh4cd3eC3OzQ7+I90tON3oddTZ6d0mtY9o8
	9der3ndPPjH9XZ15a5lc4WH2F6difyUYmc3VEv3EuJT1x7XPLRznfz56YizAsylpyiKmm50r
	33lcinymcdwrg+3ZTVNZcRO9ru7J3hNyb56JbnsaLBbo66692Co0/o3d1RlKLMUZiYZazEXF
	iQCdKKmgCwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> On Tue, Nov 20, 2012 at 02:48:58PM -0800, Doug Anderson wrote:
> > From: Olof Johansson <olof@lixom.net>
> >
> > UART3 is used for debugging on exynos5250-snow.
> >
> > [dianders: cleaned commit message.]
> >
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> >
> > ---
> >  arch/arm/Kconfig.debug        |   11 +++++++++++
> >  arch/arm/plat-samsung/Kconfig |    1 +
> >  2 files changed, 12 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> > index 33a8930..35ba7dc 100644
> > --- a/arch/arm/Kconfig.debug
> > +++ b/arch/arm/Kconfig.debug
> > @@ -355,6 +355,17 @@ choice
> >  		  The uncompressor code port configuration is now handled
> >  		  by CONFIG_S3C_LOWLEVEL_UART_PORT.
> >
> > +	config DEBUG_S3C_UART3
> > +		depends on PLAT_SAMSUNG
> 
> 
> Sorry, the reason I hadn't re-posted this is that Kukjin had proposed
> to protect users of <= 3 UART platforms to select it. An added "Depends
> on ARCH_EXYNOS4 || ARCH_EXYNOS5" should cover that. Can you add and
> repost, please?
> 
Yes, please :-)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

