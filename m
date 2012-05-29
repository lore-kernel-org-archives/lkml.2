Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2E2Oux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:50:53 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36306 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2E2Ouw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:50:52 -0400
Date: Tue, 29 May 2012 16:50:45 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [GIT PULL] CMA and ARM DMA-mapping updates for v3.5
In-reply-to: <20120529122932.GA24623@n2100.arm.linux.org.uk>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Message-id: <015e01cd3daa$6d910e50$48b32af0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Ac09lrl9VH+GBg6ASKSeY+9pdx8APAADT39A
References: <1337672417-10065-1-git-send-email-m.szyprowski@samsung.com>
 <20120529122932.GA24623@n2100.arm.linux.org.uk>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, May 29, 2012 2:30 PM Russell King - ARM Linux wrote:

> I notice we have new warnings as a result of CMA being merged, though
> thankfully they're just in Kconfig:
> 
> warning: (ARM) selects CMA which has unmet direct dependencies (HAVE_DMA_CONTIGUOUS &&
> HAVE_MEMBLOCK && EXPERIMENTAL)
> 
> This seems totally weird: you're mandating that ARM must have CMA
> selected, but it's an experimental feature?  So you're implying that
> the entire ARM kernel becomes totally experimental for the next
> release cycle?
> 
> I think this needs fixing.

No, that wasn't my intention. I will provide a patch which removes unconditional dependency
on CMA - it will let one to disable CMA and use old allocation method if needed, but this 
requires a few more changes in the dma-mapping implementation. I wasn't aware of the 
consequences and no one has complained about this since v15 of CMA patches (Aug 2011).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


