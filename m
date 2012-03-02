Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab2CBWXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:23:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab2CBWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:23:06 -0500
Date: Fri, 2 Mar 2012 14:23:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: yanmin_zhang@linux.intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Liu, ShuoX" <shuox.liu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Subject: [PATCH] cpuidle: Add a sysfs entry to disable specific
 C state for debug purpose.
Message-Id: <20120302142303.648285a7.akpm@linux-foundation.org>
In-Reply-To: <1330647453.1916.7.camel@ymzhang>
References: <C6CB66606345BC4B80CBE69D22ABFBB1021C7F@SHSMSX101.ccr.corp.intel.com>
	<1330647453.1916.7.camel@ymzhang>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2012 08:17:33 +0800
Yanmin Zhang <yanmin_zhang@linux.intel.com> wrote:

> On Wed, 2012-02-29 at 04:55 +0000, Liu, ShuoX wrote:
> > From: ShuoX Liu <shuox.liu@intel.com>
> > 
> > Some C states of new CPU might be not good. One reason is BIOS might configure
> > them incorrectly. To help developers root cause it quickly, the patch adds a
> > new sysfs entry, so developers could disable specific C state manually.
> > 
> > In addition, C state might have much impact on performance tuning, as it takes
> > much time to enter/exit C states, which might delay interrupt processing. With
> > the new debug option, developers could check if a deep C state could  impact
> > performance and how much impact it could cause.
> > 
> > Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> Andrew,
> 
> Would you like to merge the patch into your testing tree?

I can do that, but it's hardly my area and I can't comment on the
desirability of the patch and Len is having quiet time.  Perhaps the
x86 guys can take a look please>

> It's useful to help developers debug some issues.

It would help developers more if it was documented a bit.  As it
stands, they'd be lucky if they even knew it existed.

Looky:

akpm:/usr/src/linux-3.3-rc5> grep -ril cpuidle Documentation 
Documentation/trace/events-power.txt
Documentation/ABI/testing/sysfs-devices-system-cpu
Documentation/kernel-parameters.txt
Documentation/00-INDEX
Documentation/cpuidle/core.txt
Documentation/cpuidle/sysfs.txt
Documentation/cpuidle/driver.txt
Documentation/cpuidle/governor.txt

