Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2LAVri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 16:47:38 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40118 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2LAVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 16:47:37 -0500
Date: Sat, 1 Dec 2012 22:47:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] scheduler fix for autogroups
Message-ID: <20121201214731.GA6642@gmail.com>
References: <20121201111609.GA18679@gmail.com>
 <CA+55aFx_yJbonbEC5AYteyNv+qWbG-H=yj_=YaiJHwKyu4FH3Q@mail.gmail.com>
 <20121201214438.GA6544@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121201214438.GA6544@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> You are not missing anything. That flag is my fault not 
> Mike's: I booted the initial version of that patch but was 
> unsure whether autogroups was enabled - it's a pretty 
> transparent feature. So I figured that having that flag (but 
> readonly) would give us this information definitely.

The other reason was that the original version of the patch also 
added a boot parameter - to enable/disable autogroups from the 
boot command line. With *that* configuration twist it made sense 
to present this information somewhere in /proc as well.

But then we got rid of the boot parameter to simplify the patch 
- which further reduced the sense of the 
/proc/sys/kernel/sched_autogroup_enabled flag - which now can 
only ever be 1.

Thanks,

	Ingo
