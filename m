Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013Ab1CaQ1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:27:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43764 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964977Ab1CaQ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:27:17 -0400
Subject: Re: [PATCH 05/12] mm: alloc_contig_range() added
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <pawel@osciak.com>
In-Reply-To: <1301577368-16095-6-git-send-email-m.szyprowski@samsung.com>
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
	 <1301577368-16095-6-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 31 Mar 2011 09:04:05 -0700
Message-ID: <1301587445.31087.1042.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 15:16 +0200, Marek Szyprowski wrote:
> +       _start = start & (~0UL << ret);
> +       _end   = alloc_contig_freed_pages(_start, end, flag); 

These names are a wee bit lacking.  Care to give them proper names that
might let a reader figure out how the "_" makes the variable different
from its nearly-identical twin?

-- Dave

