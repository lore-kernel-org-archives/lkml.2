Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab1JFOSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:18:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10458 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab1JFOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:18:39 -0400
Date: Thu, 06 Oct 2011 16:18:36 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 7/7] ARM: integrate CMA with DMA-mapping subsystem
In-reply-to: <1317909290-29832-8-git-send-email-m.szyprowski@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org
Cc: "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>
Message-id: <000201cc8432$d642b930$82c82b90$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcyEL4b9N6bSwhmxQI62Ge/flyCSGgAAqr6g
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <1317909290-29832-8-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, October 06, 2011 3:55 PM Marek Szyprowski wrote:

> This patch adds support for CMA to dma-mapping subsystem for ARM
> architecture. By default a global CMA area is used, but specific devices
> are allowed to have their private memory areas if required (they can be
> created with dma_declare_contiguous() function during board
> initialization).
> 
> Contiguous memory areas reserved for DMA are remapped with 2-level page
> tables on boot. Once a buffer is requested, a low memory kernel mapping
> is updated to to match requested memory access type.
> 
> GFP_ATOMIC allocations are performed from special pool which is created
> early during boot. This way remapping page attributes is not needed on
> allocation time.
> 
> CMA has been enabled unconditionally for ARMv6+ systems.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Please ignore this patch. The patch named as "[PATCH 8/9] ARM: integrate
CMA with DMA-mapping subsystem" in this thread is the correct one.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

