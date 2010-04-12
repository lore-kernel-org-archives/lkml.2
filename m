Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab0DLTJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:09:05 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:53962 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab0DLTJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:09:01 -0400
Date: Mon, 12 Apr 2010 21:08:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/23] Make register values available to CRIS panic
	notifiers
Message-ID: <20100412190840.GB17147@merkur.ravnborg.org>
References: <20100412060625.GA25426@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412060625.GA25426@dvomlehn-lnx2.corp.sa.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 11, 2010 at 11:06:25PM -0700, David VomLehn wrote:
> The save_ptregs() function has not been tested or even built. I will need
> help to complete this.
> 
> Signed-off-by: David VomLehn <dvomlehn@cisco.com>
> ---
>  arch/cris/include/arch-v10/arch/ptrace.h |   80 ++++++++++++++++++++++++++++
>  arch/cris/include/arch-v32/arch/ptrace.h |   84 ++++++++++++++++++++++++++++++
>  2 files changed, 164 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/cris/include/arch-v10/arch/ptrace.h b/arch/cris/include/arch-v10/arch/ptrace.h
> index 2f464ea..28be57c 100644
> --- a/arch/cris/include/arch-v10/arch/ptrace.h
> +++ b/arch/cris/include/arch-v10/arch/ptrace.h
> @@ -114,6 +114,86 @@ struct switch_stack {
>  #define profile_pc(regs) instruction_pointer(regs)
>  extern void show_regs(struct pt_regs *);
>  
> +/* Macros for saving the contents of registers and for the output constraint
> + * for those registers */
> +#include "/home/vomlehn/git/kernel.org/ptreg.h"

The above include needs fixing.
I did not look at the rest of your patches - they may suffer the same.

PS: Your To: is seriously broken, I have to hand-edit Cc:s to send the mail

	Sam
