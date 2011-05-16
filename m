Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1EPMRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:17:30 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:33147 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752295Ab1EPMR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:17:29 -0400
Date: Mon, 16 May 2011 14:17:11 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: getter PTRACE_GETSIGINFO should not modify anything  [Re: [PATCH
 11/11] ptrace: implement group stop notification for ptracer]
Message-ID: <20110516121711.GC10469@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <20110515140232.GB31855@host1.jankratochvil.net>
 <20110515142827.GF23665@htj.dyndns.org>
 <20110515171748.GA25216@host1.jankratochvil.net>
 <20110515172811.GM23665@htj.dyndns.org>
 <20110515200654.GA32659@host1.jankratochvil.net>
 <20110516084350.GO23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516084350.GO23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Mon, 16 May 2011 10:43:50 +0200, Tejun Heo wrote:
> There's distinction between "broken" and "ugly".  If it's ugly but
> functional, you don't need to "fix" it.

The final goal is the user experience (such as the users of GDB), nothing else
matters.  If it is so "ugly" the userland developers fail to use it the
project as a whole still broken.


> Frankly, I think the biggest disease was this obsession with
> perfection.

I try to suggest fixes which seem to be easier on the kernel side than trying
to workaround them in all the debugger-like applications.  After various
strace fixes and for years gdb linux-nat fixes there is a need to move to
gdbserver which will mean to reimplement all the ptrace workarounds again.


> So, I'm gonna push back quite a bit unless it actually compromises
> functionality or correctness.

With your position "if it is workaroundable in userland let's make the new
kernel API broken again" it no longer makes sense to comment on it.  Yes,
everything is workaroundable but that is usually not the goal of new APIs.


Thanks,
Jan
