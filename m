Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2GWSqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:46:34 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:57648 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750970Ab2GWSqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:46:32 -0400
Message-ID: <500D9BFC.9090707@fold.natur.cuni.cz>
Date: Mon, 23 Jul 2012 20:46:20 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120706 Firefox/13.0.1 SeaMonkey/2.10.1
MIME-Version: 1.0
To: Mike Galbraith <mgalbraith@novell.com>
CC: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        mmokrejs@fold.natur.cuni.cz, dan.carpenter@oracle.com
Subject: Re: [QUESTION ON BUG] the rcu stall issue could not be reproduced
References: <5008CBD4.6070907@linux.vnet.ibm.com> <1342767624.7432.54.camel@marge.simpson.net>
In-Reply-To: <1342767624.7432.54.camel@marge.simpson.net>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I see few more RCU bugs reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=43028
https://bugzilla.kernel.org/show_bug.cgi?id=40092
https://bugzilla.kernel.org/show_bug.cgi?id=42997

And, I placed my previous long email with logs at
https://bugzilla.kernel.org/show_bug.cgi?id=45091

Hope this helps eventually once.
Martin

Mike Galbraith wrote:
> On Fri, 2012-07-20 at 11:09 +0800, Michael Wang wrote: 
>> Hi, Mike, Martin, Dan
>>
>> I'm currently taking an eye on the rcu stall issue which was reported by
>> you in the mail:
>>
>> rcu: endless stalls
>> 	From: Mike Galbraith
>> linux-3.4-rc7: rcu_sched self-detected stall on CPU
>> 	From: Martin Mokrejs
>> RCU stalls in linux-next
>> 	From: Dan Carpenter
>>
>> I try to reproduce the issue on my X86 server with 12 cpu
> 
> The 'endless stalls' box was 341.33333 times larger.  Dunno if you can
> even set a serial port slow enough to approximate all cores trying to
> gripe through a single pinhole simultaneously.
> 
> -Mike
> 
> 


