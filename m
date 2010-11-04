Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab0KDSia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:38:30 -0400
Received: from tundra.namei.org ([65.99.196.166]:55604 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab0KDSi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:38:27 -0400
Date: Fri, 5 Nov 2010 05:38:25 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Andr=E9_Luis_Pereira_dos_Santos_-_BSRSoft?= 
	<andre@bsrsoft.com.br>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] security: Reordering the boot message security
 framework 2.6.37-rc1
In-Reply-To: <10017.15266.qm@web110516.mail.gq1.yahoo.com>
Message-ID: <alpine.LRH.2.00.1011050537430.30945@tundra.namei.org>
References: <10017.15266.qm@web110516.mail.gq1.yahoo.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Andr? Luis Pereira dos Santos - BSRSoft wrote:

> From: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> 
> Hi.
> I did the reorganization of the boot message security framework so that it is not issued before the start in fact occur:
> 
> Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>

Your patch is whitespace damaged, probably by your mailer, and has 
converted tabs into spaces.  Please fix this.



> ---
> 
> Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> --- linux-2.6.37-rc1/security/security.c        2010-11-01 09:54:12.000000000 -0200
> +++ linux-2.6.37-rc1-patched/security/security.c        2010-11-04 15:04:04.000000000 -0200
> @@ -56,12 +56,12 @@ static void __init do_security_initcalls
>   */
>  int __init security_init(void)
>  {
> -       printk(KERN_INFO "Security Framework initialized\n");
> -
>         security_fixup_ops(&default_security_ops);
>         security_ops = &default_security_ops;
>         do_security_initcalls();
> 
> +       printk(KERN_INFO "Security Framework initialized\n");
> +
>         return 0;
>  }
> 
> 
> 
>       
> 

-- 
James Morris
<jmorris@namei.org>
