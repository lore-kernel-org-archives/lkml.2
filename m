Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1LNItk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 03:49:40 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:58298 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab1LNItj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 03:49:39 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz9371I542M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dong Aisheng <dong.aisheng@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 5/5] ASoC: mxs: correct 'direction' of
 device_prep_dma_cyclic
Thread-Topic: [PATCH 5/5] ASoC: mxs: correct 'direction' of
 device_prep_dma_cyclic
Thread-Index: AQHMujLgHUShY+dU6EmZWyX/2qAQPZXbBasA
Date: Wed, 14 Dec 2011 08:49:36 +0000
Message-ID: <7FE21149F4667147B645348EC605788503F3AE@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
 <1323848866-19768-1-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1323848866-19768-1-git-send-email-shawn.guo@linaro.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Shawn Guo
> Sent: Wednesday, December 14, 2011 3:48 PM
> To: Liam Girdwood; Mark Brown
> Cc: Dong Aisheng; alsa-devel@alsa-project.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Shawn Guo
> Subject: [PATCH 5/5] ASoC: mxs: correct 'direction' of
> device_prep_dma_cyclic
> 
> The commit 49920bc (dmaengine: add new enum dma_transfer_direction)
> changes the type of parameter 'direction' of device_prep_dma_cyclic from
> dma_data_direction to dma_transfer_direction.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  sound/soc/mxs/mxs-pcm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng


