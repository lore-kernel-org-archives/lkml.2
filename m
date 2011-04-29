Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760571Ab1D2Rck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:32:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:49976 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760512Ab1D2Rci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:32:38 -0400
Date: Fri, 29 Apr 2011 19:32:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [RFC][PATCH 1/4] clock_rtoffset: new syscall
In-Reply-To: <1303937755.1065.8.camel@zag>
Message-ID: <alpine.LFD.2.02.1104291931200.3005@ionos>
References: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>  <1303901023-11568-1-git-send-email-virtuoso@slind.org>  <alpine.LFD.2.02.1104271359580.3323@ionos> <1303937755.1065.8.camel@zag>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander,

On Wed, 27 Apr 2011, Kay Sievers wrote:
> On Wed, 2011-04-27 at 16:02 +0200, Thomas Gleixner wrote:
> > On Wed, 27 Apr 2011, Alexander Shishkin wrote:
> > The completely untested patch below should solve the same problem in a
> > sane way. Restricted to timerfd, but that really should be sufficient.
> 
> > Subject: timerfd: Allow timers to be cancelled when clock was set
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Wed, 27 Apr 2011 14:16:42 +0200
> 
> Seems to work fine for me here for the weird "cron timer" case, or the
> simple "desktop clock" use-case -- where we want to rely on the timer to
> let the process sleep as long as possible, but wake it up to recalculate
> the next wakeup in case anything has changed in the meantime.

is that sufficient to solve your problems as well?

Thanks,

	tglx
