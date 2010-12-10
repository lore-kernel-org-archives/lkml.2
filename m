Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0LJMRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:17:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab0LJMRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:17:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv1 000/211] unicore32 architecture support
Date: Fri, 10 Dec 2010 13:16:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <01ca01cb9783$7818c3f0$684a4bd0$@mprc.pku.edu.cn> <4D00A672.9050906@kernel.org> <alpine.LFD.2.00.1012091443580.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012091443580.2653@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012101316.49153.arnd@arndb.de>
X-Provags-ID: V02:K0:O8uiJLs5QP1jKti6qVbvxTqxYqmh0K5tb0t5hNzfdBr
 NOq6gVpzh3LIjGfVuaPXatGZV6ClX6oYu5BMw/bqh4NBzAx2te
 qxdb5z6ujmsXPK0OyYjH7K+eTMhWLRL19Md33L/w3q3sLGIvdm
 5tRoJG2hVeYvl2qWaz/qr62e/ER53bWhXtOLR6r/ubA0TmGtNq
 D+0/67oI0zwLmykq8gnkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 December 2010, Thomas Gleixner wrote:
> Crap. a single patch is a major PITA for review. It's even worse than
> 211 per file patches.

It doesn't matter which way is worse than the other. Both are
impractical for people to look at and not helpful.

> It's ok to have several patches ordered by topics
> 
>   - generic header stuff
>   - processor and system headers
>   - low level entry and setup code
>   - process/thread related code
>   - mm related code
>   - timers
>   - interrupts
>   - ptrace
>   - signals
>   - fault handling
>   - misc
>   - build system, main makefile, Kconfig
> 
> That makes it actually feasible to review.

Agreed.

One important step is to send patches that touch existing
architecture independent code separately from new files
that depend on the changes.

In some cases, it's also useful to send out less than the
complete set of patches at a time, but only if it is possible
to understand the patches that did get sent by themselves.
For instance, don't send a device driver implementation but
not the header files that defines the user interface and the
hardware registers.

My personal upper bound would be on the order of ten large
patches or (alternatively) twenty small patches. The size of
the individual mails often varies a lot and that's fine.
A patch containing 100kb of register definitions may be
easier to review than a one-line change in an important
place.

	Arnd
