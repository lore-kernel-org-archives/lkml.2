Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1JLMmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:42:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44574 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab1JLMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:42:33 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-dc-4e958b375e38
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Tushar Behera'" <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
References: <1317612559-8930-1-git-send-email-tushar.behera@linaro.org>
 <20111004183840.GH2870@ponder.secretlab.ca>
In-reply-to: 
Subject: RE: [PATCH] gpio/samsung: Move SoC specific codes within macro
Date: Wed, 12 Oct 2011 21:42:32 +0900
Message-id: <069501cc88dc$695fa400$3c1eec00$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyC1dy+uPOekvC0R32rCKge0AHmewAHUBcQAXeTnwA=
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> Grant Likely wrote:
> >
> > On Mon, Oct 03, 2011 at 08:59:19AM +0530, Tushar Behera wrote:
> > > In drivers/gpio/gpio-samsung.c, there are certain structures
> > > and functions which are not getting used if the particular
> > > CPU is not selected. These code segments are moved under CPU
> > > specific macros to remove compilation warnings.
> > >
> > > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> >
> > Acked-by: Grant Likely <grant.likely@secretlab.ca>
> >
> When I applied, following error was happened with s5p64x0_defconfig.
Others, ok.
> 
> ...
> Inconsistent kallsyms data
> This is a bug - please report about it
> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> make: *** [vmlinux] Error 1
> 
> And it seems due to add condition around the 'static unsigned
> s3c24xx_gpio_getcfg_abank()'.
> 
> I need to check it in detail and if any problems, let you know.
> 
There is no above problem now in my -next. Applied.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

