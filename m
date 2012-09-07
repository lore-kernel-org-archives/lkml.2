Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2IGFa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:30:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35896 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2IGFaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:30:55 -0400
X-AuditID: cbfee61a-b7fba6d000007d5f-80-5049868d7775
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Vinod Koul'" <vkoul@infradead.org>,
        "'Tushar Behera'" <tushar.behera@linaro.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, patches@linaro.org
References: <1346215585-31023-1-git-send-email-tushar.behera@linaro.org>
 <1346374330.15463.5.camel@vkoul-mobl4>
In-reply-to: <1346374330.15463.5.camel@vkoul-mobl4>
Subject: RE: [PATCH 0/2] ARM: EXYNOS: Set the capability of pdm0 and pdm1 as
 DMA_PRIVATE
Date: Fri, 07 Sep 2012 14:30:53 +0900
Message-id: <243801cd8cb9$f303e6d0$d90bb470$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2HEdt5sfrtnTOeQkqiIH13XZFufQFiWpnA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd3eNs8Ag2/3LS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKmnH/FVvCMo+LH2XNMDYy32LoYOTkkBEwkLh2cyAph
	i0lcuLceKM7FISQwnVHixqbtrBDOX0aJd5M/glWxCWhIHH7/jB3EFhEIkfizYBFYEbPAZkaJ
	7fMWMYIkhAQKJdrb5jOB2JwCxhJvL24GaxYWiJL4dnkb2GoWAVWJd70/wAbxCthK/Nyxjg3C
	FpT4MfkeC4jNLKAuMWneImYIW15i85q3QDYH0KnqEo/+6kLcYCTR/vYNI0SJiMS+F+8YJzAK
	zUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCgfia1g3Flg8Uh
	RgEORiUeXosrHgFCrIllxZW5hxglOJiVRHgn/gIK8aYkVlalFuXHF5XmpBYfYpTmYFES53U6
	ZxcgJJCeWJKanZpakFoEk2Xi4JRqYOxQ3DtNsPdl7Amp/GNeRyOnVRzJy5i6ytro1Ro+zjb1
	SUad2Xf0rW4UmC67blyg9txG7/byc7+U+wx39Fv1xBlNFhGzs1J+3thW+2Lntpg/m7Kd1382
	sQ/9v+Xb85Qdxjf3fip5Nu+Xi+7l+Vevlbg4z1mWySZRH+/vUbF9TtjbxFsHrJcy3VdiKc5I
	NNRiLipOBAAbIYNhZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vinod Koul wrote:
> 
> On Wed, 2012-08-29 at 10:16 +0530, Tushar Behera wrote:
> > DMA clients pdma0 and pdma1 are internal to the SoC and are used only
> > by dedicated peripherals. Since they cannot be used for generic
> > purpose, their capability should be set as DMA_PRIVATE.
> >
> > The patches are rebased on top of v3.6-rc3.
> Kukjin, if you ack them I can take thru my tree, other way round is fine
> with me too.

Hi Vinod,

Looks good to me, please pick them into your tree with my ack.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

If any problems, please kindly let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> >
> > Tushar Behera (2):
> >   ARM: EXYNOS: Set the capability of pdm0 and pdm1 as DMA_PRIVATE
> >   DMA: PL330: Set the capability of pdm0 and pdm1 as DMA_PRIVATE
> >
> >  arch/arm/mach-exynos/dma.c |    2 ++
> >  drivers/dma/pl330.c        |    1 +
> >  2 files changed, 3 insertions(+), 0 deletions(-)
> >
> 
> --
> ~Vinod Koul
> Intel Corp.

