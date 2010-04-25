Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0DYRp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 13:45:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53319 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab0DYRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 13:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fm22uHuEsLP7WAkmbu6DZ1JjWkEUUni/AFkEVZA6qdW2KrxZrE9L5cWS5Fvw0grDre
         yT+DJ4RNjfXtKu6q+gaIONnK5qcAXoQZfnP+2jzL/QWaIehF3dC9R8kedS/WWMRyYg3W
         Szu1uSG00vIF0+adjN55sZtrfuXaFVOuEoAPg=
Date: Sun, 25 Apr 2010 19:45:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: Cleanup useless header
Message-ID: <20100425174513.GB5375@nowhere>
References: <1272194328-7346-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272194328-7346-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 01:18:48PM +0200, Alessio Igor Bogani wrote:
> BKL isn't anymore present into this file thus it is no necessary still include smp_lock.h.
> 
> Signed-off-by: Alessio Igor Bogani <abogani@texware.it>


Please also Cc me and Arnd for bkl related things. We are trying to
keep track of every work on the bkl removal (see http://kernelnewbies.org/BigKernelLock)
so that nothing gets lost.

Especially this patch applies to one of my branches:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/core



> ---
>  kernel/ptrace.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 1d4883c..6af9cdd 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -14,7 +14,6 @@
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
>  #include <linux/pagemap.h>
> -#include <linux/smp_lock.h>



Queued, thanks!



>  #include <linux/ptrace.h>
>  #include <linux/security.h>
>  #include <linux/signal.h>
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

