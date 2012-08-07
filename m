Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2HGRKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:10:05 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33880 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2HGRKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:10:02 -0400
Message-ID: <50214BA3.8030909@us.ibm.com>
Date: Tue, 07 Aug 2012 10:08:51 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rcu stalls seen with numasched_v2 patches applied.
References: <20120807123305.GA7137@linux.vnet.ibm.com>
In-Reply-To: <20120807123305.GA7137@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080717-7408-0000-0000-0000076B83A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 05:33 AM, Srikar Dronamraju wrote:
> Hi,
>
> I saw this while I was running the 2nd August -tip kernel +  Peter's
> numasched patches.
>
> Top showed load average to be 240, there was one cpu (cpu 7) which
> showed 100% while all other cpus were idle.  The system showed some
> sluggishness. Before I saw this I ran Andrea's autonuma benchmark couple
> of times.
>
> I am not sure if this is an already reported issue/known issue.
So Ingo pushed a fix the other day that might address this:
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commitdiff_plain;h=1d17d17484d40f2d5b35c79518597a2b25296996

But do let me know any reproduction details if you can trigger this 
again.  If you do trigger it again without that patch, watch to see if 
the time value from date is running much faster then it should.

thanks
-john

