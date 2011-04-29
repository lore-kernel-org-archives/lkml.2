Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab1D2ORj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:17:39 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:55876 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757942Ab1D2ORh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:17:37 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DBAC85D.50306@freescale.com>
Date: Fri, 29 Apr 2011 09:17:01 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110410 Fedora/2.0.13-1.fc13 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/3] rename alloc_pages_exact()
References: <20110414200139.ABD98551@kernel>
In-Reply-To: <20110414200139.ABD98551@kernel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> alloc_pages_exact() returns a virtual address.  But, alloc_pages() returns
> a 'struct page *'.  That makes for very confused kernel hackers.
> 
> __get_free_pages(), on the other hand, returns virtual addresses.  That
> makes alloc_pages_exact() a much closer match to __get_free_pages(), so
> rename it to get_free_pages_exact().  Also change the arguments to have
> flags first, just like __get_free_pages().
> 
> Note that alloc_pages_exact()'s partner, free_pages_exact() already
> matches free_pages(), so we do not have to touch the free side of things.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Acked-by: Andi Kleen <ak@linux.intel.com>
> Acked-by: David Rientjes <rientjes@google.com>

All three patches:

Acked-by: Timur Tabi <timur@freescale.com>

-- 
Timur Tabi
Linux kernel developer at Freescale

