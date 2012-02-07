Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2BGJP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:15:56 -0500
Received: from mail.ingenic.cn ([124.207.145.155]:36689 "EHLO mail.ingenic.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab2BGJPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:15:54 -0500
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Feb 2012 04:15:54 EST
Message-ID: <4F30E97F.9000409@ingenic.cn>
Date: Tue, 07 Feb 2012 17:06:07 +0800
From: "cp.zou" <cpzou@ingenic.cn>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Contiguous Memory Allocator on HIGHMEM
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone!

I'm recently learning CMA, and I want to implement support for
contiguous memory areas placed in HIGHMEM zone,do you have any suggestions?

-- 
Regards,
cary.zou

