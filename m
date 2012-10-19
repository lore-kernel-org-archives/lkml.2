Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab2JSOH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:07:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:41797 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758587Ab2JSOHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:07:21 -0400
Date: Fri, 19 Oct 2012 07:07:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: stable@vger.kernel.org, tony.luck@intel.com, bp@amd64.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        miaox@cn.fujitsu.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in
 cmci_rediscover().
Message-ID: <20121019140720.GA27454@kroah.com>
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
 <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 01:45:27PM +0800, Tang Chen wrote:
> cmci_rediscover() is only called by the CPU_POST_DEAD event handler,
> which means the corresponding cpu has already dead. As a result, it
> won't be accessed in the for_each_online_cpu loop.
> So, we could change the if(cpu == dying) statement into a WARN_ON_ONCE().
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_intel.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
