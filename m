Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1LLQXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:23:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62135 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab1LLQXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:23:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 04/11] mm: compaction: export some of the functions
Date: Mon, 12 Dec 2011 16:22:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com> <op.v6dseqji3l0zgt@mpn-glaptop> <20111212154015.GI3277@csn.ul.ie>
In-Reply-To: <20111212154015.GI3277@csn.ul.ie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112121622.04236.arnd@arndb.de>
X-Provags-ID: V02:K0:uJVZRXkeprCXwmmwSPHV1iV4Kdbh6V6kTDy2eEQGdjq
 2b/5Y14TBYWS1kX5VctxEIotfDtqZREpBAJUtPlVpcGyl2SEwH
 AvvGWwYNUFWKynhq/+r3BYfiJhmxGjdnksn5mXQyPxwJDAKFnF
 PJYl+G0O2jASHhVhMMjn5HOQ4v5EItdi2Mb3BfQw49BiwEPqJG
 7NVdnYZfLTLKJH8N7x8fGGt0mEpxNWtyzqMkiPR/wf1BAX8e74
 +iogfcfHZG8lNYHlA3e1gjmE9wOccoQE6H35aG6hOBChCwi3ZT
 iVL1EO4md5AclCjR/xJzIFOdJpmts6VkR+dbumaGmkfEH6Xsrj
 zHVz+gzcZjjO2zSenbUU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 December 2011, Mel Gorman wrote:
> The bloat exists either way. I don't believe the linker strips it out so
> overall it would make more sense to depend on compaction to keep the
> vmstat counters for debugging reasons if nothing else. It's not
> something I feel very strongly about though.

There were some previous attempts to use -fgc-sections to strip out
unused functions from the kernel, but I think they were never merged
because of regressions.

	Arnd
