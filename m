Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab2FRTBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 15:01:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab2FRTBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 15:01:37 -0400
Message-ID: <4FDF7AC4.9020008@redhat.com>
Date: Mon, 18 Jun 2012 15:00:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        peterz@infradead.org, minchan@gmail.com, kosaki.motohiro@gmail.com,
        hnaz@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 3/6] Fix the x86-64 page colouring code to take pgoff
 into account and use that code as the basis for a generic page colouring
 code.
References: <1340029878-7966-1-git-send-email-riel@redhat.com> <1340029878-7966-4-git-send-email-riel@redhat.com> <m2k3z48twb.fsf@firstfloor.org> <4FDF5B3C.1000007@redhat.com> <20120618181658.GA7190@x1.osrc.amd.com>
In-Reply-To: <20120618181658.GA7190@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 02:16 PM, Borislav Petkov wrote:
> On Mon, Jun 18, 2012 at 12:45:48PM -0400, Rik van Riel wrote:
>>> What tree is that against? I cannot find x86 page colouring code in next
>>> or mainline.
>>
>> This is against mainline.
>
> Which mainline do you mean exactly?
>
> 1/6 doesn't apply ontop of current mainline and by "current" I mean
> v3.5-rc3-57-g39a50b42f702.

I git pulled on Friday, then used guilt to apply and rediff
all the patches. I pull from here:

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

I see no g39a50b... commit after pulling that tree here.
Do you have any local changes by chance?

-- 
All rights reversed
