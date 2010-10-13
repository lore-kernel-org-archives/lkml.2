Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab0JMNrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:47:10 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50208 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab0JMNrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:47:09 -0400
Date: Wed, 13 Oct 2010 14:46:56 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, npiggin@kernel.dk,
        yanmin_zhang@linux.intel.com
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
Message-ID: <20101013134656.GP30667@csn.ul.ie>
References: <20101005185725.088808842@linux.com> <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com> <20101012182531.GH30667@csn.ul.ie> <4CB55CDD.9010908@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4CB55CDD.9010908@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 10:16:45AM +0300, Pekka Enberg wrote:
>  On 10/12/10 9:25 PM, Mel Gorman wrote:
>> On Wed, Oct 06, 2010 at 11:01:35AM +0300, Pekka Enberg wrote:
>>> (Adding more people who've taken interest in slab performance in the
>>> past to CC.)
>>>
>> I have not come even close to reviewing this yet but I made a start on
>> putting it through a series of tests. It fails to build on ppc64
>>
>>    CC      mm/slub.o
>> mm/slub.c:1477: warning: 'drain_alien_caches' declared inline after being called
>> mm/slub.c:1477: warning: previous declaration of 'drain_alien_caches' was here
>
> Can you try the attached patch to see if it fixes the problem?

I didn't resend it though testing and I don't have my hands on the tree
right now but your patch looks reasonable.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
