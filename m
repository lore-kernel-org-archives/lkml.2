Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab2ERIep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:34:45 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65136 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362Ab2ERIen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:34:43 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-89-4fb609a075cf
Message-ID: <4FB609CF.3060307@kernel.org>
Date: Fri, 18 May 2012 17:35:27 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, a.p.zijlstra@chello.nl,
        Nick Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 3/3] x86: Support local_flush_tlb_kernel_range
References: <1337133919-4182-1-git-send-email-minchan@kernel.org> <1337133919-4182-3-git-send-email-minchan@kernel.org> <4FB4B29C.4010908@kernel.org> <20120517144622.GA27597@kroah.com>
In-Reply-To: <20120517144622.GA27597@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 05/17/2012 11:46 PM, Greg Kroah-Hartman wrote:

> On Thu, May 17, 2012 at 05:11:08PM +0900, Minchan Kim wrote:
>> Isn't there anyone for taking a time to review this patch? :)
>>
>> On 05/16/2012 11:05 AM, Minchan Kim wrote:
> 
> <snip>
> 
> You want review within 24 hours for a staging tree patch for a feature
> that no one uses?
> 
> That's very bold of you.  Please be realistic.


I admit I was hurry because I thought portability issue of zsmalloc may
be a urgent issue for [zram|zsmalloc] to go out of staging and I want to
move [zsmalloc|zram] into mainline as soon as possible.

I should have grown my patience.

As an excuse, exactly speaking, it's not 24 hours because I sent first
patch 5/14 and I didn't change that patch from then. :)

-- 
Kind regards,
Minchan Kim
