Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054Ab1D0VmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:42:23 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:57220
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759270Ab1D0VmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:42:22 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DB88DAF.2010504@freescale.com>
Date: Wed, 27 Apr 2011 16:42:07 -0500
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
References: <20110414200139.ABD98551@kernel>	 <20110414200140.CDE09A20@kernel>  <4DB88AF0.1050501@freescale.com> <1303940249.9516.366.camel@nimitz>
In-Reply-To: <1303940249.9516.366.camel@nimitz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
>> Is there an easy way to verify that alloc_pages_exact(5MB) really does allocate
>> > only 5MB and not 8MB?

> I'm not sure why you're asking.  How do we know that the _normal_
> allocator only gives us 4k when we ask for 4k?  Well, that's just how it
> works.  If alloc_pages_exact() returns success, you know it's got the
> amount of memory that you asked for, and only that plus a bit of masking
> for page alignment.
> 
> Have you seen alloc_pages_exact() behaving in some other way?

I've never tested this part of alloc_pages_exact(), even when I wrote (the first
version of) it.  I just took it on faith that it actually did what it was
supposed to do.

-- 
Timur Tabi
Linux kernel developer at Freescale

