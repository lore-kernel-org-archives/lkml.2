Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0DMQU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:20:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36961 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0DMQUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tSGRSV+qA6Joz78E8+EeJ4LQBR+qn2bZanvjVgMzusBVZ+3xpyftamycq+4Sf7HwVy
         tzSwbxTVVUmO2AEvVOywuC6/whLe/HZi6WanIIrIdm1r4TCT55Kk7hTsGTBS8HFOflts
         3F0R3cQ5il6KiQYo0JVU/k4MouRMWdG6oP5NY=
MIME-Version: 1.0
In-Reply-To: <20100413161326.GG25756@csn.ul.ie>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <d74305233536342dfeb1ca7ffe9e83495ce1f285.1271171877.git.minchan.kim@gmail.com>
	 <20100413161326.GG25756@csn.ul.ie>
Date: Wed, 14 Apr 2010 01:20:55 +0900
Message-ID: <j2z28c262361004130920s649c3f41mb35e39aa3621083a@mail.gmail.com>
Subject: Re: [PATCH 6/6] Add comment in alloc_pages_exact_node
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 1:13 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Wed, Apr 14, 2010 at 12:25:03AM +0900, Minchan Kim wrote:
>> alloc_pages_exact_node naming makes some people misleading.
>> They considered it following as.
>> "This function will allocate pages from node which I wanted
>> exactly".
>> But it can allocate pages from fallback list if page allocator
>> can't find free page from node user wanted.
>>
>> So let's comment this NOTE.
>>
>
> It's a little tough to read. How about
>
> /*
>  * Use this instead of alloc_pages_node when the caller knows
>  * exactly which node they need (as opposed to passing in -1
>  * for current). Fallback to other nodes will still occur
>  * unless __GFP_THISNODE is specified.
>  */

It is better than mine.

>
> That at least will tie in why "exact" is in the name?
>
>> Actually I wanted to change naming with better.
>> ex) alloc_pages_explict_node.
>
> "Explicit" can also be taken to mean "this and only this node".

I agree.
I will repost modified comment after Tejun comment [2/6].
Thanks for quick review, Mel. :)
-- 
Kind regards,
Minchan Kim
