Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab0IBVKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:10:32 -0400
Received: from xenotime.net ([72.52.115.56]:41361 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757607Ab0IBVKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:10:19 -0400
Date: Thu, 2 Sep 2010 14:10:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH 02/91] arch/alpha/Kconfig Update broken web addresses in
 the arch directory.
Message-Id: <20100902141012.9769b977.rdunlap@xenotime.net>
In-Reply-To: <1283461606-7803-3-git-send-email-justinmattock@gmail.com>
References: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
	<1283461606-7803-3-git-send-email-justinmattock@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Sep 2010 14:06:33 -0700 Justin P. Mattock wrote:

> The below patch updates a broken web address that is no longer
> working due to company buyout, and/or change of location.
> (Please have a look through, and let me know if any of them
> need to be changed, and I'll resend an updated patch).
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  arch/alpha/Kconfig |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index b9647bb..16ae162 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -219,7 +219,8 @@ config ALPHA_LX164
>  	bool "LX164"
>  	help
>  	  A technical overview of this board is available at
> -	  <http://www.unix-ag.org/Linux-Alpha/Architectures/LX164.html>.
> +	  <http://web.archive.org/web/*/http://www.unix-ag.org/
> +	  Linux-Alpha/Architectures/LX164.html>.
>  
>  config ALPHA_LYNX
>  	bool "Lynx"
> @@ -483,7 +484,8 @@ config ALPHA_AVANTI
>  	help
>  	  Avanti AS 200, AS 205, AS 250, AS 255, AS 300, and AS 400-based
>  	  Alphas. Info at
> -	  <http://www.unix-ag.org/Linux-Alpha/Architectures/Avanti.html>.
> +	  <http://web.archive.org/web/*/http://www.unix-ag.org/Linux-Alpha/
> +	  Architectures/Avanti.html>.
>  
>  config ALPHA_BROKEN_IRQ_MASK
>  	bool
> -- 

I wouldn't split long URLs, regardless of any column limit _guidelines_.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
