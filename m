Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab2BIKXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:23:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64967 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757753Ab2BIKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:23:38 -0500
X-AuditID: cbfee61b-b7be3ae0000039aa-11-4f339ea9e59d
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Karol Lewandowski'" <k.lewandowsk@samsung.com>
Cc: thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
References: <1328028434-30139-1-git-send-email-k.lewandowsk@samsung.com>
 <1328028434-30139-2-git-send-email-k.lewandowsk@samsung.com>
 <4F3390D0.7040209@samsung.com>
In-reply-to: <4F3390D0.7040209@samsung.com>
Subject: RE: [PATCH] ARM: Exynos4: Bring exynos4-dt up to date
Date: Thu, 09 Feb 2012 19:23:40 +0900
Message-id: <067e01cce714$e44dfc20$ace9f460$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcznDJOrPoNTXOejQ1G7Rp3KJch6+gABdfWQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karol Lewandowski wrote:
> 
> On 31.01.2012 17:47, Karol Lewandowski wrote:
> 
> > This commit brings exynos4-dt in line with recent changes to
> > mach-exynos tree, specifically:
> >
> >  - Fixes build break related to replacing plat/exynos4.h with common.h
> >    in commit cc511b8d84d8 ("ARM: 7257/1: EXYNOS: introduce
> >    arch/arm/mach-exynos/common.[ch]")
> 
> 
> 
> >  - Converts machine to use CONFIG_MULTI_IRQ_HANDLER as done for other
> >    machines in commit 4e44d2cb95bd ("ARM: exynos4: convert to
> >    CONFIG_MULTI_IRQ_HANDLER") converted all exynos boards but
> >    exynos4-dt.c.
> 
> 
> Minor correction - text from "converted all.." shall be deleted, like:
> 
>    - Converts machine to use CONFIG_MULTI_IRQ_HANDLER as done for other
>      machines in commit 4e44d2cb95bd ("ARM: exynos4: convert to
>      CONFIG_MULTI_IRQ_HANDLER")
> 
> (It's result of not proofreading it carefully enough after squashing all
> the patches.)
> 
> I don't think such a change is worth sending patch again, but I would be
> grateful if you could fix it while merging.
> 
OK, I did.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

