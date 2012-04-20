Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2DTSb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:31:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:54169 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab2DTSb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:31:56 -0400
Subject: Re: [PATCHv24 00/16] Contiguous Memory Allocator
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20120419124044.632bfa49.akpm@linux-foundation.org>
Date: Fri, 20 Apr 2012 13:30:29 -0500
Cc: "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Linux Memory Management <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sandeep Patil <psandeep.s@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <D4B49754-F153-4600-AB79-49FD72D7D378@kernel.crashing.org>
References: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com> <20120419124044.632bfa49.akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek,

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1601e5..669e8bb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -508,6 +508,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
                        Also note the kernel might malfunction if you disable
                        some critical bits.
 
+       cma=nn[MG]      [ARM,KNL]

Just a nit, but should that really have [ARM] ?

+                       Sets the size of kernel global memory area for contiguous
+                       memory allocations. For more information, see
+                       include/linux/dma-contiguous.h
+


