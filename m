Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab0KOS7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:59:07 -0500
Received: from kroah.org ([198.145.64.141]:43672 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016Ab0KOS66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:58:58 -0500
Date: Mon, 15 Nov 2010 10:49:44 -0800
From: Greg KH <greg@kroah.com>
To: Len Brown <lenb@kernel.org>
Cc: stable@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [git pull 2.6.36.stable] intel_idle patches for
 2.6.36.stable
Message-ID: <20101115184944.GB9597@kroah.com>
References: <alpine.LFD.2.00.1011151227190.2939@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011151227190.2939@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 12:29:05PM -0500, Len Brown wrote:
> Hi Greg,
> 
> please pull from: 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.36.git idle-release
> 
> to sync 2.6.36.y with upstream changes to the intel_idle driver.
> 
> After applying this series, 2.6.36.y and upstream intel_idle.c
> are identical.

That's nice, but why would I do this?  I need git commit ids for the
upstream patches that went into Linus's tree, and they should only be
bug fixes or other stuff that is applicable for -stable.

> commit 935558a7fefe0a307618857ad8a06e8a485b3b47
> Author: Len Brown <len.brown@intel.com>
> Date:   Wed Jul 7 00:12:03 2010 -0400
> 
>     intel_idle: add initial Sandy Bridge support
>     
>     Signed-off-by: Len Brown <len.brown@intel.com>

Is this patch really ok for -stable?  What is the git commit id of it in
Linus's tree?

> commit 1768bd405dc30d4db74af5eb693d6c2d3389c5a6
> Author: Len Brown <len.brown@intel.com>
> Date:   Fri Oct 15 21:23:25 2010 -0400
> 
>     intel_idle: delete bogus data from cpuidle_state.power_usage
>     
>     The mW data in this field is a total fabrication
>     and serves no purpose other than to mislead
>     those who might see it in sysfs.  Delete it.
>     
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> commit 645fd1ddc110eea7ab596b6fa27add5cff912e84
> Author: Len Brown <len.brown@intel.com>
> Date:   Fri Oct 15 20:43:06 2010 -0400
> 
>     intel_idle: simplify test for leave_mm()
>     
>     A run-time test to invoke leave_mm() for the deepest
>     supported C-state is redundant, since the appropriate
>     C-states already have flags with CPUIDLE_FLAG_TLB_FLUSHED set.
>     
>     Signed-off-by: Len Brown <len.brown@intel.com>

Is this patch really for -stable?

> commit 27a52cf2d75b81e762c8fc41fd8fca3dac2aa8ca
> Author: H. Peter Anvin <hpa@linux.intel.com>
> Date:   Fri Sep 17 15:36:40 2010 -0700
> 
>     x86, mwait: Move mwait constants to a common header file
>     
>     We have MWAIT constants spread across three different .c files, for no
>     good reason.  Move them all into a common header file.
>     
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>     Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
>     Cc: Len Brown <lenb@kernel.org>
>     LKML-Reference: <tip-*@git.kernel.org>

Why would this be ok for -stable?

While I understand you would like the driver to be the same in both
kernel versions, you still have to follow the normal -stable rules.

thanks,

greg k-h
