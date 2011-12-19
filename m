Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab1LSFUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 00:20:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54654 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1LSFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 00:20:21 -0500
Message-ID: <4EEEC988.2060309@gmail.com>
Date: Mon, 19 Dec 2011 13:20:08 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy.c: use enum value MPOL_REBIND_ONCE instead
 of 0 in mpol_rebind_policy
References: <4EE8A461.2080406@gmail.com> <alpine.DEB.2.00.1112141840550.27595@chino.kir.corp.google.com> <4EEC9D54.502@gmail.com> <alpine.DEB.2.00.1112181444530.1364@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1112181444530.1364@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年12月19日 06:45, David Rientjes wrote:
> 
> On Sat, 17 Dec 2011, Wang Sheng-Hui wrote:
> 
>>> Tip: when proposing patches, it's helpful to run scripts/get_maintainer.pl 
>>> on your patch file from git to determine who should be cc'd on the email.
>>
>> Thanks for your tip.
>> I have tried the script with option -f, and only get the mm, kernel mailing
>> lists, no specific maintainer provided. So here I just posted the patch to 
>> these 2 lists.
>>
> 
> $ ./scripts/get_maintainer.pl -f mm/mempolicy.c
> Andrew Morton <akpm@linux-foundation.org> (commit_signer:19/23=83%)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> (commit_signer:8/23=35%)
> Stephen Wilson <wilsons@start.ca> (commit_signer:6/23=26%)
> Andrea Arcangeli <aarcange@redhat.com> (commit_signer:5/23=22%)
> Johannes Weiner <hannes@cmpxchg.org> (commit_signer:3/23=13%)
> linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
> linux-kernel@vger.kernel.org (open list)
> 
> All of those people should be cc'd on patches touching mm/mempolicy.c.
Got it. Thanks,
