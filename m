Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0FDMDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 08:03:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:47202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab0FDMDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 08:03:46 -0400
Message-ID: <4C08EB74.8070300@kernel.org>
Date: Fri, 04 Jun 2010 14:03:00 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       paulus@samba.org, acme@redhat.com, Paul Menage <menage@google.com>
Subject: Re: [PATCH UPDATED 2/4] sched: adjust when cpu_active and cpuset
 configurations are updated during cpu on/offlining
References: <1275332199-28082-1-git-send-email-tj@kernel.org>	 <1275332199-28082-3-git-send-email-tj@kernel.org>	 <1275407846.27810.27627.camel@twins>  <4C053C39.9070405@kernel.org>	 <1275412835.27810.27887.camel@twins>  <4C0680DB.9010503@kernel.org> <1275652701.27810.39745.camel@twins>
In-Reply-To: <1275652701.27810.39745.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Jun 2010 12:03:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2010 01:58 PM, Peter Zijlstra wrote:
>> * Rollback on failure.
>>
>> * cpuset/sched_domain don't expect to be called before smp
>>   configuration is complete.  If hardcoded into cpu_up/down(),
>>   condition checks need to be added so that they're skipped if the
>>   system is bringing up the cpus for the first time.
>>
>> Works fine here w/ CPUSET enabled and disabled.
> 
> OK, this looks good. 

Cool, can I add your acked-by's to and send them towards Ingo?

Thanks.

-- 
tejun
