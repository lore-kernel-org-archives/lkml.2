Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2CEBfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 20:35:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:34211 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab2CEBfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 20:35:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="133351759"
Subject: Re: Subject: [PATCH] cpuidle: Add a sysfs entry to disable
 specific C state for debug purpose.
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Liu, ShuoX" <shuox.liu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20120302142303.648285a7.akpm@linux-foundation.org>
References: <C6CB66606345BC4B80CBE69D22ABFBB1021C7F@SHSMSX101.ccr.corp.intel.com>
	 <1330647453.1916.7.camel@ymzhang>
	 <20120302142303.648285a7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Mon, 05 Mar 2012 09:34:31 +0800
Message-ID: <1330911271.1916.14.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 14:23 -0800, Andrew Morton wrote:
> On Fri, 02 Mar 2012 08:17:33 +0800
> Yanmin Zhang <yanmin_zhang@linux.intel.com> wrote:
> 
> > On Wed, 2012-02-29 at 04:55 +0000, Liu, ShuoX wrote:
> > > From: ShuoX Liu <shuox.liu@intel.com>
> > > 
> > > Some C states of new CPU might be not good. One reason is BIOS might configure
> > > them incorrectly. To help developers root cause it quickly, the patch adds a
> > > new sysfs entry, so developers could disable specific C state manually.
> > > 
> > > In addition, C state might have much impact on performance tuning, as it takes
> > > much time to enter/exit C states, which might delay interrupt processing. With
> > > the new debug option, developers could check if a deep C state could  impact
> > > performance and how much impact it could cause.
> > > 
> > > Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> > Andrew,
> > 
> > Would you like to merge the patch into your testing tree?
> 
> I can do that, but it's hardly my area and I can't comment on the
> desirability of the patch and Len is having quiet time.  Perhaps the
> x86 guys can take a look please>
> 
> > It's useful to help developers debug some issues.
> 
> It would help developers more if it was documented a bit.  As it
> stands, they'd be lucky if they even knew it existed.
> 
> Looky:
> 
> akpm:/usr/src/linux-3.3-rc5> grep -ril cpuidle Documentation 
> Documentation/trace/events-power.txt
> Documentation/ABI/testing/sysfs-devices-system-cpu
> Documentation/kernel-parameters.txt
> Documentation/00-INDEX
> Documentation/cpuidle/core.txt
> Documentation/cpuidle/sysfs.txt
> Documentation/cpuidle/driver.txt
> Documentation/cpuidle/governor.txt
Thanks Andrew. We checked above document files. The best place to record
the new entry is Documentation/cpuidle/sysfs.txt. We would change it and
resend the patch.


