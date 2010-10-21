Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab0JUVuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:50:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56021 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab0JUVuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gJCcfEAQm5ExkXfCwyJTIPHbePMiznR2O4jGdux6PA+hr1feK1ZqmyWKhNyQeS2J/s
         pcneiR4ARQJK0LId54qKf0Hrj0vg56Ml3mOBy3YbpVNEemwjEpjAR2SmF1g+RRSswaxf
         T74gac3CH2pt2vG73vxXW8t4H4o4S6dgMsohI=
MIME-Version: 1.0
In-Reply-To: <20101021202336.GA3318@sucs.org>
References: <AANLkTikKFnVOFr70u_2Hdtz0mXuAEckWWUy885m_ut--@mail.gmail.com>
	<20101021202336.GA3318@sucs.org>
Date: Thu, 21 Oct 2010 17:50:21 -0400
Message-ID: <AANLkTi=upG5Sw=shimWb12YST-XaJYdrYBJCOdTjp_vg@mail.gmail.com>
Subject: Re: Disable L1/L2/L3 cache and MTRR
From: Andev <debiandev@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux kernel <kernelnewbies@nl.linux.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 4:23 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

>> Now when I run some sample benchmarks they show a slowdown of almost 1000x!!
>>
>> This is not reasonable since the max. The slowdown I was expecting is 200x
>> considering that it will take 200 cycles to read from DRAM.
>
> Assuming the cache was completely disabled, won't the impact be
> cumulative? E.g. imagine a memory read takes one cycle from cache and
> 100 from main memory. If you read 5 instructions from cache that will
> take 5 cycles. If you read 5 instructions from main memory that will be
> 5*100 so 500 cycles. If it is 10 instructions then it is 10 vs 1000 and
> so on...
>
> Are you searching for an improvement in determinism?

Yes, if that was so, the slowdown is still 100x.

In my test case, I removed all the entries from /proc/mtrr and also
disabled L1/L2/L3 caches.
When I run a benchmark which runs for 4 sec with cache, it takes
almost 3000 secs without cache.

I think I am messing up the /proc/mtrr file.

Regards,
Andev.
