Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0FKFj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:39:26 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:38127 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0FKFjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:39:24 -0400
Message-ID: <4C11CC08.9080503@in.ibm.com>
Date: Fri, 11 Jun 2010 11:09:20 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: maciej.rutecki@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: Re: 2.6.35-rc2 : OOPS with LTP memcg regression test run.
References: <4C0BB98E.9030101@in.ibm.com> <201006102200.57617.maciej.rutecki@gmail.com> <20100611103509.520671b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100611103509.520671b2.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 10 Jun 2010 22:00:57 +0200
> Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
>
>   
>> I created a Bugzilla entry at 
>> https://bugzilla.kernel.org/show_bug.cgi?id=16178
>> for your bug report, please add your address to the CC list in there, thanks!
>>
>>     
>
> Hmm... It seems a panic in SLUB or SLAB.
> Is .config available ?
>   
I think the root cause for this problem was same as the one
mentioned in this thread (Bug kmalloc-4096 : Poison overwritten)

http://marc.info/?l=linux-kernel&m=127586004308747&w=2 <http://marc.info/?l=linux-kernel&m=127586004308747&w=2>

I verified that the problem goes away after applying the commit 386f40c.

Thanks
-Sachin 


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

