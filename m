Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab1DBAYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 20:24:16 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56235 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab1DBAYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 20:24:14 -0400
Date: Sat, 2 Apr 2011 09:24:10 +0900
From: Norbert Preining <preining@logic.at>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org
Subject: Re: Lenovo resume from suspends hangs in i915_gpu_busy or so
Message-ID: <20110402002410.GL6464@gamma.logic.tuwien.ac.at>
References: <20110401021055.GB6071@gamma.logic.tuwien.ac.at> <20110401051511.GE9128@gamma.logic.tuwien.ac.at> <20110401090817.01717af0@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401090817.01717af0@jbarnes-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 01 Apr 2011, Jesse Barnes wrote:
> > Copyied from screen:
> > Process ips-adjust (....
> > Stack:
> >   ....
> >    ....
> >   ...
> > Call Trace:
> >   <IRQ>
> >   ... ? tick_program_event
> >   call_sortirq
> >   do_softirq
> >   irq_exit
> >   smp_apic_timer_interrupt
> >   apic_timer_interrupt
> >   <EOI>
> >   ? _raw_spin_lock
> >   i915_gpu_busy
> >   ips_adjust
> >   ? show_cpu_temp
> >   kthread
> >   kernel_thread_helper
> >   ? kthread_worker_fn
> >   ? gs_change
> > Code: ...
> > (once more more or less the same as above)
> 
> Hm, ok so on resume we're checking GPU busyness, which is normal, but
> end up hanging on the spinlock?  Do you see what scrolls by above the
> text you took a picture of (probably a "task hung" message?).

More than what I can see on the screen shot I cannot grasp.

> Does this happen reliably?  Does a previous kernel work ok?

Reliable: yes
Previous: I don't know, but I can try out some older git release.
   which one do you suggest?
  (I got the laptop recently so I don't have a long history with that one)

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SCRONKEY (n.)
Something that hits the window as a result of a violent sneeze.
			--- Douglas Adams, The Meaning of Liff
