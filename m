Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1HORh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:37:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42788 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1HORh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:37:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [Bug #37432] sdhci-pci fails on 3.0.0-rc1 on Dell E6510
Date: Mon, 15 Aug 2011 19:39:09 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera> <bkwpSnItbJM.A.FcB.0OCSOB@chimera> <4E4951C5.203@hartkopp.net>
In-Reply-To: <4E4951C5.203@hartkopp.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108151939.10007.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 15, 2011, Oliver Hartkopp wrote:
> On 14.08.2011 21:02, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.39 and 3.0.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.39 and 3.0.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37432
> > Subject		: sdhci-pci fails on 3.0.0-rc1 on Dell E6510
> > Submitter	: Oliver Hartkopp <socketcan@hartkopp.net>
> > Date		: 2011-06-07 20:06 (69 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/da7822e5ad71ec9b745b412639f1e5e0ba795a20
> > References	: http://article.gmane.org/gmane.linux.kernel.mmc/8442
> > 		  https://lkml.org/lkml/2011/6/23/660
> > 
> 
> Hello Rafael,
> 
> the regression has been solved for 3.0 by disabling the problematic code here:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=f483d3923dc3a6394c483e28ccb3fe700bdf399e
> 
> When the new commandline argument 'pci=realloc' is not set (which is the
> default) the buggy code is disabled.
> 
> Therefore this bug can be closed on the 2.6.39 -> 3.0 regression list.

Thanks, closing!

Rafael
