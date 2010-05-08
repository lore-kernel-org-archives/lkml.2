Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab0EHH03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 03:26:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36078 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0EHH02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 03:26:28 -0400
Message-ID: <4BE5120B.10408@cs.helsinki.fi>
Date: Sat, 08 May 2010 10:26:03 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: ngupta@vflare.org
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data from compressed memory
 (v2)
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org> <20100507155504.10532b3e.akpm@linux-foundation.org> <4BE504AD.4030807@cs.helsinki.fi> <4BE50B71.4020202@vflare.org>
In-Reply-To: <4BE50B71.4020202@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> Oops, missed this part:
> 
> On 05/08/2010 11:59 AM, Pekka Enberg wrote: 
>> Andrew Morton wrote:
>>> I've completely forgotten why we need this xvmalloc thing and I don't
>>> recall whether we decided it would be a good thing to have as a generic
>>> facility and of course it's all unexplained and undocumented.  I won't
>>> be looking at it today, for this reason.
>> We need it because the slab allocator is not a good fit for this special
>> purpose driver due to fragmentation. Nitin, you had a nice web page
>> showing all the relevant numbers but I can't find it anymore.
>>
> 
> xvmalloc performance numbers:
> http://code.google.com/p/compcache/wiki/xvMalloc
> http://code.google.com/p/compcache/wiki/xvMallocPerformance

I don't see the xvmalloc vs. kmalloc fragmentation numbers there. I 
thought you had some?
