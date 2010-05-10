Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0EJFta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:49:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:59022 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab0EJFt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:49:28 -0400
Message-ID: <4BE79E46.2080305@kernel.org>
Date: Mon, 10 May 2010 07:48:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, efault@gmx.de,
       avi@redhat.com, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1272976724-14312-1-git-send-email-tj@kernel.org> <1272994165.1642.203.camel@laptop> <4BE0FB68.7080403@kernel.org> <1273050400.1642.229.camel@laptop> <4BE13B33.3030709@kernel.org> <1273053073.1642.235.camel@laptop> <4BE1406C.2000400@kernel.org> <20100510052056.GB20793@drongo>
In-Reply-To: <20100510052056.GB20793@drongo>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 05:49:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/10/2010 07:20 AM, Paul Mackerras wrote:
> Don't forget where perf_events started out - as a way to count and
> record hardware events.  So perf_events is very useful even in a
> kernel that has no tracing infrastructure configured in at all. 

Alright, but I don't think it's very relevant to worry about
!CONFIG_TRACEPOINTS && CONFIG_PERF_EVENTS case as long as both can be
compiled out.  TPs are supposed to have very low to almost no runtime
overhead and building them into the kernel shouldn't cost all that
much either (I hear that it has been improved lately).  Sure, perf can
be used w/o TPs but I can't see what that configurability buys us.

Thanks.

-- 
tejun
