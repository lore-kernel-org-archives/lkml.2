Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2L1XWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 18:22:49 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:40343 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab2L1XWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 18:22:47 -0500
Date: Sat, 29 Dec 2012 00:22:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Andreas Schwab <schwab@linux-m68k.org>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/tags.sh: Fix regex syntax for etags
In-Reply-To: <m2han5wza1.fsf_-_@igel.home>
Message-ID: <alpine.LNX.2.00.1212290022100.32254@swampdragon.chaosbits.net>
References: <CA+8YGd6UqfbzEHOb2NUL5p3EF4OECVq7yc2vRV3GViVT64CTbQ@mail.gmail.com> <20121227184034.GA2982@debian.debian> <CABuSbKbk5DdhvuwYUeLkm=eub1CsSaOB_oX7bkBZcAV_MNsSdg@mail.gmail.com> <CAK7N6vpvLrAb=sZitaEBQ6Fx4K5ehGg+LTU70hiVK=1RdE4WwQ@mail.gmail.com>
 <CAOUxTKNgs4N-M5RR6YHyGeXQqRrg0_CJpxgT2OmN_buEP+jbjQ@mail.gmail.com> <CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com> <87a9syhbma.fsf@xmission.com> <20121228130734.GB13224@x1.alien8.de> <Pine.LNX.4.64.1212282321370.2539@axis700.grange>
 <m2han5wza1.fsf_-_@igel.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2012, Andreas Schwab wrote:

> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
>  scripts/tags.sh | 50 +++++++++++++++++++++++++-------------------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 08f06c0..4c53b7d 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -201,34 +201,34 @@ exuberant()
>  emacs()
>  {
>  	all_target_sources | xargs $1 -a                        \
> -	--regex='/^(ENTRY|_GLOBAL)(\([^)]*\)).*/\2/'            \
> +	--regex='/^\(ENTRY\|_GLOBAL\)(\([^)]*\)).*/\2/'         \
>  	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
>  	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
>  	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/' \
> -	--regex='/PAGEFLAG\(([^,)]*).*/Page\1/'			\
> -	--regex='/PAGEFLAG\(([^,)]*).*/SetPage\1/'		\
> -	--regex='/PAGEFLAG\(([^,)]*).*/ClearPage\1/'		\
> -	--regex='/TESTSETFLAG\(([^,)]*).*/TestSetPage\1/'	\
> -	--regex='/TESTPAGEFLAG\(([^,)]*).*/Page\1/'		\
> -	--regex='/SETPAGEFLAG\(([^,)]*).*/SetPage\1/'		\
> -	--regex='/__SETPAGEFLAG\(([^,)]*).*/__SetPage\1/'	\
> -	--regex='/TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
> -	--regex='/__TESTCLEARFLAG\(([^,)]*).*/TestClearPage\1/'	\
> -	--regex='/CLEARPAGEFLAG\(([^,)]*).*/ClearPage\1/'	\
> -	--regex='/__CLEARPAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
> -	--regex='/__PAGEFLAG\(([^,)]*).*/__SetPage\1/'		\
> -	--regex='/__PAGEFLAG\(([^,)]*).*/__ClearPage\1/'	\
> -	--regex='/PAGEFLAG_FALSE\(([^,)]*).*/Page\1/'		\
> -	--regex='/TESTSCFLAG\(([^,)]*).*/TestSetPage\1/'	\
> -	--regex='/TESTSCFLAG\(([^,)]*).*/TestClearPage\1/'	\
> -	--regex='/SETPAGEFLAG_NOOP\(([^,)]*).*/SetPage\1/'	\
> -	--regex='/CLEARPAGEFLAG_NOOP\(([^,)]*).*/ClearPage\1/'	\
> -	--regex='/__CLEARPAGEFLAG_NOOP\(([^,)]*).*/__ClearPage\1/' \
> -	--regex='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
> -	--regex='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
> -	--regex='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
> -	--regex='/PCI_OP_READ\(([a-z]*[a-z]).*[1-4]\)/pci_bus_read_config_\1/' \
> -	--regex='/PCI_OP_WRITE\(([a-z]*[a-z]).*[1-4]\)/pci_bus_write_config_\1/'
> +	--regex='/PAGEFLAG(\([^,)]*\).*/Page\1/'			\
> +	--regex='/PAGEFLAG(\([^,)]*\).*/SetPage\1/'		\
> +	--regex='/PAGEFLAG(\([^,)]*\).*/ClearPage\1/'		\
> +	--regex='/TESTSETFLAG(\([^,)]*\).*/TestSetPage\1/'	\
> +	--regex='/TESTPAGEFLAG(\([^,)]*\).*/Page\1/'		\
> +	--regex='/SETPAGEFLAG(\([^,)]*\).*/SetPage\1/'		\
> +	--regex='/__SETPAGEFLAG(\([^,)]*\).*/__SetPage\1/'	\
> +	--regex='/TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
> +	--regex='/__TESTCLEARFLAG(\([^,)]*\).*/TestClearPage\1/'	\
> +	--regex='/CLEARPAGEFLAG(\([^,)]*\).*/ClearPage\1/'	\
> +	--regex='/__CLEARPAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
> +	--regex='/__PAGEFLAG(\([^,)]*\).*/__SetPage\1/'		\
> +	--regex='/__PAGEFLAG(\([^,)]*\).*/__ClearPage\1/'	\
> +	--regex='/PAGEFLAG_FALSE(\([^,)]*\).*/Page\1/'		\
> +	--regex='/TESTSCFLAG(\([^,)]*\).*/TestSetPage\1/'	\
> +	--regex='/TESTSCFLAG(\([^,)]*\).*/TestClearPage\1/'	\
> +	--regex='/SETPAGEFLAG_NOOP(\([^,)]*\).*/SetPage\1/'	\
> +	--regex='/CLEARPAGEFLAG_NOOP(\([^,)]*\).*/ClearPage\1/'	\
> +	--regex='/__CLEARPAGEFLAG_NOOP(\([^,)]*\).*/__ClearPage\1/' \
> +	--regex='/TESTCLEARFLAG_FALSE(\([^,)]*\).*/TestClearPage\1/' \
> +	--regex='/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/' \
> +	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
> +	--regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
> +	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'
>  
>  	all_kconfigs | xargs $1 -a                              \
>  	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
> 

This works for me. Thanks.

Tested-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

