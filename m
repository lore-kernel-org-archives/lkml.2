Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab2HGRw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:52:56 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47414 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2HGRwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:52:55 -0400
Date: Tue, 7 Aug 2012 22:29:32 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rcu stalls seen with numasched_v2 patches applied.
Message-ID: <20120807165932.GA3850@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120807123305.GA7137@linux.vnet.ibm.com>
 <50214BA3.8030909@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <50214BA3.8030909@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080717-8974-0000-0000-00000BEB5CD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* John Stultz <johnstul@us.ibm.com> [2012-08-07 10:08:51]:

> On 08/07/2012 05:33 AM, Srikar Dronamraju wrote:
> >Hi,
> >
> >I saw this while I was running the 2nd August -tip kernel +  Peter's
> >numasched patches.
> >
> >Top showed load average to be 240, there was one cpu (cpu 7) which
> >showed 100% while all other cpus were idle.  The system showed some
> >sluggishness. Before I saw this I ran Andrea's autonuma benchmark couple
> >of times.
> >
> >I am not sure if this is an already reported issue/known issue.
> So Ingo pushed a fix the other day that might address this:
> http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commitdiff_plain;h=1d17d17484d40f2d5b35c79518597a2b25296996

Okay, will update after applying the patch.

> 
> But do let me know any reproduction details if you can trigger this
> again.  If you do trigger it again without that patch, watch to see
> if the time value from date is running much faster then it should.
> 

The time value from date is normal

-- 
Thanks and Regards
Srikar

