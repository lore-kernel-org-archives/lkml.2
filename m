Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2HGPWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:22:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53310 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2HGPWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:22:19 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-79-502132a94491
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hideki EIRAKU'" <hdk@igel.co.jp>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jaroslav Kysela'" <perex@perex.cz>, "'Takashi Iwai'" <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, "'Katsuya MATSUBARA'" <matsu@igel.co.jp>
References: <1344246924-32620-1-git-send-email-hdk@igel.co.jp>
 <1344246924-32620-2-git-send-email-hdk@igel.co.jp>
In-reply-to: <1344246924-32620-2-git-send-email-hdk@igel.co.jp>
Subject: RE: [PATCH v3 1/4] ARM: dma-mapping: define ARCH_HAS_DMA_MMAP_COHERENT
Date: Tue, 07 Aug 2012 17:22:02 +0200
Organization: SPRC
Message-id: <013301cd74b0$691eba60$3b5c2f20$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1zubn7BzlhlQ7iQkO5v6TDrJuMCQA9mGLg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jQd2VRooBBvcnylmc6PvAanF51xw2
	i54NW1kdmD0+b5ILYIzisklJzcksSy3St0vgylj1/SZzwU+OisMrLjI2MC5n72Lk5JAQMJE4
	srSZGcIWk7hwbz0biC0kMJ1RYsVypi5GLiD7J6PErYu3mUASbAKGEl1vu8CKRASuMEkc6iwB
	KWIWOMkocfXRZ0aI7mKJp7cvgNmcAvYS8z9uZQGxhQX8JV7/+gzWzCKgKvHt6TLWLkYODn4B
	IYmJsxRAwrwCLhI79jUzQtiCEj8m3wNrZRbQkli/8zgThC0vsXnNW2aQVgkBdYlHf3UhzjGS
	+H/kISNEiYjE3YbnrBMYhWchmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpe
	cn7uJkZwyD+T3sG4qsHiEKMAB6MSD+9MFYUAIdbEsuLK3EOMEhzMSiK8h3cChXhTEiurUovy
	44tKc1KLDzFKc7AoifOaeH/1FxJITyxJzU5NLUgtgskycXBKNTCund374+Eq50+3l7CEFc89
	y9f2z4xrTueZpKt6M1ZJF5zgZ1i9x0Mz5DuD8wq/yR7J3LHXbl4T/Xtf3vTVlqOfFglIF1X6
	f55/eM2jpSp2i349LrwcFLrPaKrgxFfPkxiFppYdPXBz0pHpeUdzb35xTnhfq/T28Fzv38He
	+RY3tux+dZaxZPuLcCWW4oxEQy3mouJEAHGlQmx1AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hideki,

On Monday, August 06, 2012 11:55 AM Hideki EIRAKU wrote:

> ARCH_HAS_DMA_MMAP_COHERENT indicates that there is dma_mmap_coherent() API
> in this architecture.  The name is already defined in PowerPC.
> 
> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
> ---
>  arch/arm/include/asm/dma-mapping.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index bbef15d..f41cd30 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -187,6 +187,7 @@ extern int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
>  			struct dma_attrs *attrs);
> 
>  #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, NULL)
> +#define ARCH_HAS_DMA_MMAP_COHERENT
> 
>  static inline int dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
>  				  void *cpu_addr, dma_addr_t dma_addr,
> --
> 1.7.0.4

I will take this patch to my dma-mapping kernel tree, to the fixes branch.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


