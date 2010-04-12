Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0DLT3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:29:08 -0400
Received: from pqueueb.post.tele.dk ([193.162.153.10]:37567 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0DLT3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:29:06 -0400
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Apr 2010 15:29:06 EDT
Date: Mon, 12 Apr 2010 21:06:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/23] Make register values available to Alpha panic
	notifiers
Message-ID: <20100412190509.GA17147@merkur.ravnborg.org>
References: <20100412060613.GA25303@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412060613.GA25303@dvomlehn-lnx2.corp.sa.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 11, 2010 at 11:06:13PM -0700, David VomLehn wrote:
> The save_ptregs() function has not been tested or even built. I will need
> help to complete this.
> 
> Signed-off-by: David VomLehn <dvomlehn@cisco.com>
> ---
>  arch/alpha/include/asm/ptrace.h |  124 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 124 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/alpha/include/asm/ptrace.h b/arch/alpha/include/asm/ptrace.h
> index 65cf3e2..952d177 100644
> --- a/arch/alpha/include/asm/ptrace.h
> +++ b/arch/alpha/include/asm/ptrace.h
> @@ -79,6 +79,130 @@ extern void show_regs(struct pt_regs *);
>  
>  #define force_successful_syscall_return() (task_pt_regs(current)->r0 = 0)
>  
> +/* Macros for saving the contents of registers and for the output constraint
> + * for those registers */
> +#include "/home/vomlehn/git/kernel.org/linux/ptreg.h"
The above include needs fixing.

	Sam
