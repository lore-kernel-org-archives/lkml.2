Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab1D0Vaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:30:55 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:59106
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929Ab1D0Vay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:30:54 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DB88AF0.1050501@freescale.com>
Date: Wed, 27 Apr 2011 16:30:24 -0500
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
Subject: Re: [PATCH 2/3] make new alloc_pages_exact()
References: <20110414200139.ABD98551@kernel> <20110414200140.CDE09A20@kernel>
In-Reply-To: <20110414200140.CDE09A20@kernel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> 
> What I really wanted in the end was a highmem-capable
> alloc_pages_exact(), so here it is.  This function can be used to
> allocate unmapped (like highmem) non-power-of-two-sized areas of
> memory.  This is in constast to get_free_pages_exact() which can only
> allocate from lowmem.

Is there an easy way to verify that alloc_pages_exact(5MB) really does allocate
only 5MB and not 8MB?  Is there some kind of function that returns the amount of
unallocated memory, so I can do a diff?

-- 
Timur Tabi
Linux kernel developer at Freescale

