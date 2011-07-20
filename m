Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab1GTPVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 11:21:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302Ab1GTPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 11:21:16 -0400
Date: Wed, 20 Jul 2011 08:24:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Vitaliy Ivanov <vitalivanov@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: `make headers_check' bustage
Message-Id: <20110720082402.843ecbcd.akpm@linux-foundation.org>
In-Reply-To: <4E26A332.8010304@suse.cz>
References: <20110707171627.4f15035e.akpm@linux-foundation.org>
	<20110717144746.78063c97.rdunlap@xenotime.net>
	<CAGTPOqdP6OwZ2dF+1J3rxL0aBag5ir+_-ge1n_4UWWUMc1949Q@mail.gmail.com>
	<4E26A03E.10707@suse.cz>
	<CAGTPOqeMgXXtVnGZ8R1rQT2nMyiOdt3vTOi0nF4o7h2ETkxRxw@mail.gmail.com>
	<4E26A332.8010304@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011 11:43:14 +0200 Michal Marek <mmarek@suse.cz> wrote:

> On 20.7.2011 11:36, Vitaliy Ivanov wrote:
> > On Wed, Jul 20, 2011 at 12:30 PM, Michal Marek<mmarek@suse.cz>  wrote:
> >> And it exits with non-zero? Please run make headers_check; echo $?
>  >
> >    CHECK   include/linux (366 files)
> > /home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6/usr/include/linux/kernel.h:65:
> > userspace cannot reference function or variable defined in the kernel
> > /home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6/usr/include/linux/quota.h:175:
> > userspace cannot reference function or variable defined in the kernel
> > /home/TOROKI-UA/vitaliy.ivanov/PRIVATE/KERNEL/LINUX-2.6/build-linux-2.6/usr/include/linux/soundcard.h:1054:
> > userspace cannot reference function or variable defined in the kernel
> > [...]
> > Wed Jul 20 12:33:50
> > [vitaliy.ivanov@vivanov linux-2.6]$ echo $?
> > 0
> 
> So it works as expected; the warnings have been there for a long time 
> and are not fatal. But Andrew says it exits with non-zero :(.
> 

I need to recheck why the build was erroring out.  Last time I tried it
it did not, so perhaps it was due to something else.  Later this week,
hopefully.

