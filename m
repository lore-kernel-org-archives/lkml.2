Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1HISbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:31:53 -0400
Received: from smtp3.Stanford.EDU ([171.67.219.83]:34344 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751799Ab1HISbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:31:51 -0400
Message-ID: <4E417D12.70608@localhost>
Date: Tue, 09 Aug 2011 11:31:46 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Subject: Re: [ANNOUNCE] 3.0.1-rt8
References: <1312580681.28695.44.camel@twins>
In-Reply-To: <1312580681.28695.44.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 02:44 PM, Peter Zijlstra wrote:
> Hi,
>
> Since yesterday is old, and yesterday's kernels aren't interesting,
> here's a fresh one: 3.0.1-rt8.

Hmmm, what are reasonable values for CONFIG_RCU_BOOST_PRIO and 
CONFIG_RCU_BOOST_DELAY? (or at least what are you using?). I think 
CONFIG_RCU_BOOST should be working now so I should reenable the option 
for my next build.

-- Fernando


> Aside from the obvious rebase to 3.0.1 changes include:
>
>   - a fix from Rostedt for his cpupri rework involving memory ordering
>   - a fix from me regarding this highmem muck, seeing as I mostly
>     wrecked things last time around :-)
>   - some lockdep annotations from upstream for things people were
>     seeing here as well
>   - a patch from Clark adding a sysfs file to recognize a PREEMP_RT
>     kernel for udev -- is there really no saner solution !?
>   - and a fresh raw_spinlock_t conversion of cpufreq_driver_lock, done
>     just minutes before releasing this, to keep life interesting.
>
> Still working on the known issues from last time..
>
> The patch is at:
>
>    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0.1-rt8.patch.bz2
>
> The quilt series can be found here:
>
>    http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt8.tar.bz2
>
> Once kernel.org mirrors catch up that is..
