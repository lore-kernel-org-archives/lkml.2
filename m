Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1LQNrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 08:47:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64390 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1LQNrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 08:47:19 -0500
Message-ID: <4EEC9D54.502@gmail.com>
Date: Sat, 17 Dec 2011 21:47:00 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy.c: use enum value MPOL_REBIND_ONCE instead
 of 0 in mpol_rebind_policy
References: <4EE8A461.2080406@gmail.com> <alpine.DEB.2.00.1112141840550.27595@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1112141840550.27595@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年12月15日 10:42, David Rientjes wrote:
> On Wed, 14 Dec 2011, Wang Sheng-Hui wrote:
> 
>> We have enum definition in mempolicy.h: MPOL_REBIND_ONCE.
>> It should replace the magic number 0 for step comparison in
>> function mpol_rebind_policy.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Tip: when proposing patches, it's helpful to run scripts/get_maintainer.pl 
> on your patch file from git to determine who should be cc'd on the email.

Thanks for your tip.
I have tried the script with option -f, and only get the mm, kernel mailing
lists, no specific maintainer provided. So here I just posted the patch to 
these 2 lists.
