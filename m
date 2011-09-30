Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1I3UmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:42:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40440 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab1I3UmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:42:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v13 0/4] Devfreq, DVFS Framework for Non-CPU Devices
Date: Fri, 30 Sep 2011 22:44:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
        Pavel Machek <pavel@ucw.cz>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Kevin Hilman <khilman@ti.com>, Nishanth Menon <nm@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@ti.com>, myungjoo.ham@gmail.com
References: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109302244.37584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 29, 2011, MyungJoo Ham wrote:
> Summary of update from the patchset v12:
> 
> - Bugfix: _remove_devfreq and devfreq_dev_release may be called multiple times.
> 
> - Fixup kerneldoc comments.
> 
> Reposting to LKML as Kernel-PM list seems broken.
> 
> I didn't put Kevin's ACK at 2/4 patch as there has been changes in 2/4 patch
> (the bugfix mentioned above).
> 
> MyungJoo Ham (4):
>   PM / OPP: Add OPP availability change notifier.
>   PM: Introduce devfreq: generic DVFS framework with device-specific
>     OPPs
>   PM / devfreq: add common sysfs interfaces
>   PM / devfreq: add basic governors

Applied to linux-pm/pm-devfreq (new branch) and merged into the linux-next
branch.  I'm going to push this patchset for 3.2, thank everyone involved!

Rafael
