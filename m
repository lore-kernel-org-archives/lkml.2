Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab0LSWZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 17:25:32 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11814 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0LSWZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 17:25:31 -0500
Date: Sun, 19 Dec 2010 23:16:25 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Benjamin <masterme120@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add optimisation option for k10 processors
In-Reply-To: <1292795132.14811.10.camel@benjamin-desktop>
Message-ID: <alpine.LNX.2.00.1012192314440.9633@swampdragon.chaosbits.net>
References: <1292795132.14811.10.camel@benjamin-desktop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Dec 2010, Benjamin wrote:

> From: Benjamin Fair <masterme120@gmail.com>
> 
> This adds a config option to optimise for AMD family-k10 processors.
> 
> Signed-off-by: Benjamin Fair <masterme120@gmail.com>
> 
> diff -uNr linux-2.6.37-rc6.vanilla/arch/x86/Kconfig.cpu
> linux-2.6.37-rc6/arch/x86/Kconfig.cpu
> --- linux-2.6.37-rc6.vanilla/arch/x86/Kconfig.cpu	2010-12-15
> 20:24:48.000000000 -0500
> +++ linux-2.6.37-rc6/arch/x86/Kconfig.cpu	2010-12-19 14:31:59.034429012
> -0500
> @@ -171,6 +171,13 @@
>  	  Enables use of some extended instructions, and passes appropriate
>  	  optimization flags to GCC.
>  
> +config MK10
> +	bool "Phenom/Phenom-II/Athlon-II/K10/10h"
> +	---help---
> +	  Select this for an AMD K10-family processor.  Also known as Family
> +	  10h.  Enables use of some extended instructions, and passes
> +	  appropriate  optimization flags to GCC.

Extreme nitpicking, but why do you have two spaces between 
"appropriate" and "optimization" here?

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

