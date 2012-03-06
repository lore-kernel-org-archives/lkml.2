Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab2CFHxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:53:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab2CFHxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:53:41 -0500
Date: Mon, 5 Mar 2012 23:55:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, alex.shi@intel.com, cl@gentwo.org,
        sfr@canb.auug.org.au, tj@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 5/8] x86: use this_cpu_xxx to replace percpu_xxx funcs
Message-Id: <20120305235532.28f407bf.akpm@linux-foundation.org>
In-Reply-To: <20120306074601.GD23669@elte.hu>
References: <20120305230515.A9238A02AE@akpm.mtv.corp.google.com>
	<20120306074601.GD23669@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 08:46:01 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> Will percpu_write() be removed altogether? If so then the 
> changelog should say *that*, and explain that on x86 this is a 
> simple renaming of the API, not a long explanation about 
> scenarios that don't actually matter.
> 
> If percpu_write() is not being removed then I don't see how this 
> patch is an improvement: it's supposed to result in the same 
> instructions being emitted, and __this_cpu_write() et al are 
> distinctly longer to write ...
> 
> So what's the plan here?

All percpu_xxx() functions get removed.

That was explained in the [patch 0/n] changelog (available on lkml ;))
but a) I chose to feed the prereq patches through maintainers and b) I
didn't edit all the changelogs.  I should have.

