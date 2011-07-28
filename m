Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab1G1Suj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 14:50:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:43317 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab1G1Sug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 14:50:36 -0400
Date: Thu, 28 Jul 2011 20:50:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Don Zickus <dzickus@redhat.com>
cc: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: WARNING at watchdog_overflow_callback in 3.0-rc7+
In-Reply-To: <20110728183521.GA26882@redhat.com>
Message-ID: <alpine.LFD.2.02.1107282048430.2660@ionos>
References: <4E1DD3AF.80201@candelatech.com> <20110728183521.GA26882@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, Don Zickus wrote:

> On Wed, Jul 13, 2011 at 10:19:43AM -0700, Ben Greear wrote:
> > This is on the same nfs testing machine I've been posting about.  This
> > has some additional nfs patches included, running tests to mount, do io, unmount
> > over and over again.  Seems that the NFS bugs might be finally fixed, but
> > system is still un-stable in general:
> 
> This looks like it is stuck spinning on a lock while trying to cancel an
> hrtimer.  Not sure under what conditions the hrtimer can't get this lock.
> 
> I cc'd Thomas, perhaps he might know.

http://www.gossamer-threads.com/lists/linux/kernel/1409228

Fix is on the way to mainline/stable

Thanks,

	tglx
