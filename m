Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0FDHoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:44:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:40164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab0FDHn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:43:59 -0400
Message-ID: <4C08AEA5.1050406@kernel.org>
Date: Fri, 04 Jun 2010 09:43:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       paulus@samba.org, acme@redhat.com, Paul Menage <menage@google.com>
Subject: Re: [PATCH UPDATED 2/4] sched: adjust when cpu_active and cpuset
 configurations are updated during cpu on/offlining
References: <1275332199-28082-1-git-send-email-tj@kernel.org>	 <1275332199-28082-3-git-send-email-tj@kernel.org>	 <1275407846.27810.27627.camel@twins>  <4C053C39.9070405@kernel.org> <1275412835.27810.27887.camel@twins> <4C0680DB.9010503@kernel.org>
In-Reply-To: <4C0680DB.9010503@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Jun 2010 07:43:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 06:03 PM, Tejun Heo wrote:
> Okay, how about this one?  Using notifiers seems better for the
> following reasons.
> 
> * Rollback on failure.
> 
> * cpuset/sched_domain don't expect to be called before smp
>   configuration is complete.  If hardcoded into cpu_up/down(),
>   condition checks need to be added so that they're skipped if the
>   system is bringing up the cpus for the first time.
> 
> Works fine here w/ CPUSET enabled and disabled.

Ping. Peter.

-- 
tejun
