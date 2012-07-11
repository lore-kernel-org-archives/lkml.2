Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030373Ab2GKWGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:06:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58825 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030271Ab2GKWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:06:47 -0400
Date: Wed, 11 Jul 2012 15:06:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jason Vas Dias <jason.vas.dias@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Comrade DOS <suloevdmitry@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Performance drop
Message-ID: <20120711220643.GD10930@kroah.com>
References: <CA+fU7qen=cwc1vMY1bv21_0GuNKXPQZXsQLVszYG1WG_r1XUGA@mail.gmail.com>
 <20120524123116.GA4048@alberich.amd.com>
 <CA+fU7qfPznJpRABC4Z=xmRZW6p5Mw3dFLBySk9HuPnaCYMMnEg@mail.gmail.com>
 <20120529140940.GA10421@alberich.amd.com>
 <CA+fU7qdKYA3KJr3xET_evO_1ztSKh0K0csn5Coro7Mkv_my+eg@mail.gmail.com>
 <20120530124333.GA3008@alberich.amd.com>
 <CALyZvKxcdNWMHEGwgdO=sGTTs9sZYerYXcQEyqFwixKzzz3giA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALyZvKxcdNWMHEGwgdO=sGTTs9sZYerYXcQEyqFwixKzzz3giA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 03:40:58PM +0100, Jason Vas Dias wrote:
> I can confirm that the AMD Turion X2 2.2Ghz  HP Compaq 6715b
> "business" x86_64 k8 dual-core laptops circa 2007
> DO get stuck in 800Khz mode  and cannot switch out of it after booting
> the "stable" "v3.4.4" tagged kernel.
> 
> I followed the containing post and reverted commit
> ff74ae50f01ee67764564815c023c362c87ce18b :
> 
> Commit d51cdad33bb5bb370c05129f7c7f3a16a55eff40
> Author: root <root@jvdspc.localdomain>
> Date:   Fri Jul 6 18:57:03 2012 +0000
> 
>     Revert "ACPI: Evaluate thermal trip points before reading temperature"
> 
>     This reverts commit 9bcb8118965ab4631a65ee0726e6518f75cda6c5.
> 
> commit ff74ae50f01ee67764564815c023c362c87ce18b
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Fri Jun 22 11:37:50 2012 -0700
> 
> And wow !  what a difference - back to a circa 2007 machine versus  a
> circa 1987 machine.
> 
> Not too many of us  left around trying to run the latest version of
> linux on nearly 5-year-old hardware I guess, but still -
> please can you restore correct Linux cpufreq & thermal operation on
> old-style AMD k8 CPUs ?
> They do seem to depend on the temperature being set BEFORE 1st entry .
> 
> Thanks & Regards,
> Jason Vas Dias (a Software Engineer) <jason.vas.dias@gmail.com>

Any reason you didn't include the original developers of the
9bcb8118965ab4631a65ee0 patch?

Matthew, Len, any ideas?

greg k-h
