Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab0EEJzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:55:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:39035 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab0EEJzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:55:23 -0400
Message-ID: <4BE1406C.2000400@kernel.org>
Date: Wed, 05 May 2010 11:54:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1272976724-14312-1-git-send-email-tj@kernel.org>	 <1272994165.1642.203.camel@laptop>  <4BE0FB68.7080403@kernel.org>	 <1273050400.1642.229.camel@laptop>  <4BE13B33.3030709@kernel.org> <1273053073.1642.235.camel@laptop>
In-Reply-To: <1273053073.1642.235.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 09:54:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/05/2010 11:51 AM, Peter Zijlstra wrote:
>> I was wondering the other way around - ie. the possibility to make
>> perf optional and maybe even as a module which depends on TPs, which
>> would be nicer than the current situation and make the code less
>> cluttered too. 
> 
> I really really hate making perf rely on tracepoints.

Hmmm.... may I ask why?  Unifying hooking mechanism seems like a good
idea to me and it's not like it's gonna add any runtime overhead
although it does complicate init/exit but well that's something you
have to pay if you wanna do things dynamically and sans the ifdef
stuff it's like a couple hundred lines of isolated code.

Thanks.

-- 
tejun
