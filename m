Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1EBILG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:11:06 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:52087 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1EBILD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:11:03 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: Thomas Gleixner <tglx@linutronix.de>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [RFC][PATCH 1/4] clock_rtoffset: new syscall
In-Reply-To: <alpine.LFD.2.02.1104291931200.3005@ionos>
References: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>  <1303901023-11568-1-git-send-email-virtuoso@slind.org>  <alpine.LFD.2.02.1104271359580.3323@ionos> <1303937755.1065.8.camel@zag> <alpine.LFD.2.02.1104291931200.3005@ionos>
User-Agent: Notmuch/0.5-83-g74bc93f (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Mon, 02 May 2011 11:10:59 +0300
Message-ID: <87y62pmsj0.fsf@shisha.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 19:32:13 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> Alexander,
> 
> On Wed, 27 Apr 2011, Kay Sievers wrote:
> > On Wed, 2011-04-27 at 16:02 +0200, Thomas Gleixner wrote:
> > > On Wed, 27 Apr 2011, Alexander Shishkin wrote:
> > > The completely untested patch below should solve the same problem in a
> > > sane way. Restricted to timerfd, but that really should be sufficient.
> > 
> > > Subject: timerfd: Allow timers to be cancelled when clock was set
> > > From: Thomas Gleixner <tglx@linutronix.de>
> > > Date: Wed, 27 Apr 2011 14:16:42 +0200
> > 
> > Seems to work fine for me here for the weird "cron timer" case, or the
> > simple "desktop clock" use-case -- where we want to rely on the timer to
> > let the process sleep as long as possible, but wake it up to recalculate
> > the next wakeup in case anything has changed in the meantime.
> 
> is that sufficient to solve your problems as well?

Yes, it looks to be.

Thanks,
--
Alex
