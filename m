Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1JNJOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:14:44 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55799 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab1JNJOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:14:42 -0400
Date: Fri, 14 Oct 2011 11:14:25 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [Linaro-mm-sig] [PATCH 8/9] ARM: integrate CMA with DMA-mapping
 subsystem
In-reply-to: <4E97BB8E.3060204@gmail.com>
To: "'Subash Patel'" <subashrp@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
Message-id: <013701cc8a51$ab1a3fb0$014ebf10$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcyKKm0RIRmfQc6USYKCCIgBtEo2JQAJvzFw
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <1317909290-29832-10-git-send-email-m.szyprowski@samsung.com>
 <4E97BB8E.3060204@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, October 14, 2011 6:33 AM Subash Patel wrote:

> Hi Marek,
> 
> As informed to you in private over IRC, below piece of code broke during
> booting EXYNOS4:SMDKV310 with ZONE_DMA enabled.

Right, I missed the fact that ZONE_DMA can be enabled but the machine does not
provide specific zone size. I will fix this in the next version. Thanks for 
pointing this bug!

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


