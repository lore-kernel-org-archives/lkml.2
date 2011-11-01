Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1KASsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:48:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45438 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1KASsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:48:04 -0400
Date: Tue, 1 Nov 2011 18:47:59 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9] mm: alloc_contig_freed_pages() added
Message-ID: <20111101184759.GE14998@csn.ul.ie>
References: <20111018122109.GB6660@csn.ul.ie>
 <809d0a2afe624c06505e0df51e7657f66aaf9007.1319428526.git.mina86@mina86.com>
 <20111101150448.GD14998@csn.ul.ie>
 <op.v394luhl3l0zgt@mpn-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <op.v394luhl3l0zgt@mpn-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 07:06:56PM +0100, Michal Nazarewicz wrote:
> >page_isolation.c may also be a better fit than page_alloc.c
> 
> Since isolate_freepages_block() is the only user of split_free_page(),
> would it make sense to move split_free_page() to page_isolation.c as
> well?  I sort of like the idea of making it static and removing from
> header file.
> 

I see no problem with that. It'll be separate from split_page() but that
is not earth shattering.

Thanks.

-- 
Mel Gorman
SUSE Labs
