Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab2GFRYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:24:21 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:45981 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750774Ab2GFRYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:24:20 -0400
Message-ID: <4FF71F1C.4040608@xenotime.net>
Date: Fri, 06 Jul 2012 10:23:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] CONFIG_CC_STACKPROTECTOR is no longer experimental
References: <1341583705.4655.18.camel@amber.site>
In-Reply-To: <1341583705.4655.18.camel@amber.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 07:08 AM, Jean Delvare wrote:

> This feature has been around for over 5 years now, so I presume it is
> no longer considered experimental.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> ---
> Or is there any reason to still consider this an experimental feature?


I doubt it, but if it is still experimental, it should also have
	depends on EXPERIMENTAL

and then it would be nice if kconfig (the software) would add the
  " (EXPERIMENTAL)" tag when it sees such a dependency.


> 
>  arch/x86/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-3.5-rc5.orig/arch/x86/Kconfig	2012-06-05 16:22:58.000000000 +0200
> +++ linux-3.5-rc5/arch/x86/Kconfig	2012-07-06 15:32:55.660276577 +0200
> @@ -1525,7 +1525,7 @@ config SECCOMP
>  	  If unsure, say Y. Only embedded should say N here.
>  
>  config CC_STACKPROTECTOR
> -	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
> +	bool "Enable -fstack-protector buffer overflow detection"
>  	---help---
>  	  This option turns on the -fstack-protector GCC feature. This
>  	  feature puts, at the beginning of functions, a canary value on
> 



-- 
~Randy
