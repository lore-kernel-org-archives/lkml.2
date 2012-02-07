Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab2BGJsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:48:53 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44971 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab2BGJsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:48:51 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Tue, 07 Feb 2012 10:48:48 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Contiguous Memory Allocator on HIGHMEM
In-reply-to: <4F30E97F.9000409@ingenic.cn>
To: "'cp.zou'" <cpzou@ingenic.cn>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>
Message-id: <003601cce57d$b0df2af0$129d80d0$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: Aczld7zmvUQGSkPWQXqtF/jnlo+JqwABGn5A
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
 <4F30E97F.9000409@ingenic.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, February 07, 2012 10:06 AM cp.zou wrote:

> Hello everyone!
> 
> I'm recently learning CMA, and I want to implement support for
> contiguous memory areas placed in HIGHMEM zone,do you have any suggestions?

CMA memory management core (migration and allocation of pages) should support
areas placed in HIGHMEM without any additional works. The main limitation is
in the DMA-mapping framework. Right now it makes certain assumptions about page
mappings to simplify allocation process. You need to add support for dynamic
mappings there. 

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


