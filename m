Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3ADJwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:52:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab3ADJv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:51:56 -0500
Date: Fri, 4 Jan 2013 10:51:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Masanari Iida <standby24x7@gmail.com>
Cc: chris@zankel.net, jcmvbkbc@gmail.com, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][trivial] xtensa: Fix home page URL in Kconfig
In-Reply-To: <1357288158-29654-1-git-send-email-standby24x7@gmail.com>
Message-ID: <alpine.LNX.2.00.1301041051430.9143@pobox.suse.cz>
References: <1357288158-29654-1-git-send-email-standby24x7@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2013, Masanari Iida wrote:

> This home page address has moved to new one.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  arch/xtensa/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
> index 0d1f36a..75fb260 100644
> --- a/arch/xtensa/Kconfig
> +++ b/arch/xtensa/Kconfig
> @@ -22,7 +22,7 @@ config XTENSA
>  	  configurable and extensible.  The Linux port to the Xtensa
>  	  architecture supports all processor configurations and extensions,
>  	  with reasonable minimum requirements.  The Xtensa Linux project has
> -	  a home page at <http://xtensa.sourceforge.net/>.
> +	  a home page at <http://www.linux-xtensa.org/>.
>  
>  config RWSEM_XCHGADD_ALGORITHM
>  	def_bool y

I am taking it, thanks.

-- 
Jiri Kosina
SUSE Labs
