Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0KPFgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 00:36:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0KPFge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 00:36:34 -0500
Subject: Re: [PATCH] kernel/sysctl.c: Fix build failure with !CONFIG_PRINTK
From: Eric Paris <eparis@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1289884647.16461.186.camel@Joe-Laptop>
References: <201011160259.oAG2x1UX012045@hera.kernel.org>
	 <1289884647.16461.186.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 00:36:13 -0500
Message-ID: <1289885773.14282.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 21:17 -0800, Joe Perches wrote:
> Sigh...
> 
> Signed-off-by: Joe Perches <joe@perches.com>

eparis fails again.

Acked-by: Eric Paris <eparis@redhat.com>

> ---
>  kernel/sysctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index b65bf63..5abfa15 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -702,7 +702,6 @@ static struct ctl_table kern_table[] = {
>  		.extra1		= &zero,
>  		.extra2		= &ten_thousand,
>  	},
> -#endif
>  	{
>  		.procname	= "dmesg_restrict",
>  		.data		= &dmesg_restrict,
> @@ -712,6 +711,7 @@ static struct ctl_table kern_table[] = {
>  		.extra1		= &zero,
>  		.extra2		= &one,
>  	},
> +#endif
>  	{
>  		.procname	= "ngroups_max",
>  		.data		= &ngroups_max,
> 
> 


