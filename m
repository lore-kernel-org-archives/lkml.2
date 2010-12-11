Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab0LKAKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:10:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:37178 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab0LKAKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:10:02 -0500
Message-ID: <4D02C14E.80001@kernel.org>
Date: Sat, 11 Dec 2010 01:09:50 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 03/10] workqueue: It is likely that WORKER_NOT_RUNNING
 is true
References: <20101207015834.196176991@goodmis.org>	 <20101207021328.847976021@goodmis.org>  <4CFE0346.6090904@kernel.org> <1292026104.5015.1540.camel@gandalf.stny.rr.com>
In-Reply-To: <1292026104.5015.1540.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 11 Dec 2010 00:09:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2010 01:08 AM, Steven Rostedt wrote:
> On Tue, 2010-12-07 at 10:49 +0100, Tejun Heo wrote:
> 
>> Yeah, I was lost thinking about the busiest case where workers are
>> busy processing works consecutively.  Usually workers are of course
>> switching in and out of idle state all the time.
>>
>> How about just dropping likely/unlikely?
> 
> OK, if I just remove it, can I add your Acked-by?

Sure, then, I'll route it through my tree.

Thanks.

-- 
tejun
