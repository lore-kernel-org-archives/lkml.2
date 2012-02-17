Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2BQUiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:38:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51451 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2BQUiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:38:51 -0500
Message-ID: <4F3EBAD7.6090705@openvz.org>
Date: Sat, 18 Feb 2012 00:38:47 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ARM: __enabled_CONFIG_NUMA undeclared
References: <CAOMZO5CarXUJ1XVJMWCEt1AXvnE5Gvunou_8nydjLmPVkZERMA@mail.gmail.com>
In-Reply-To: <CAOMZO5CarXUJ1XVJMWCEt1AXvnE5Gvunou_8nydjLmPVkZERMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Estevam wrote:
> Hi,
>
> Building today's linux-next for ARM:
>
>    CC      arch/arm/kernel/asm-offsets.s
> In file included from include/linux/mm.h:8:0,
>                   from arch/arm/kernel/asm-offsets.c:14:
> include/linux/gfp.h: In function 'gfp_zonelist':
> include/linux/gfp.h:267:1: error: '__enabled_CONFIG_NUMA' undeclared
> (first use in this function)
> include/linux/gfp.h:267:1: note: each undeclared identifier is
> reported only once for each function it appears in
> include/linux/gfp.h:267:1: error: '__enabled_CONFIG_NUMA_MODULE'
> undeclared (first use in this function)
> make[1]: *** [arch/arm/kernel/asm-offsets.s] Error 1
>
> , which is caused by commit 053361e1a (mm: replace NUMA_BUILD with
> IS_ENABLED(CONFIG_NUMA)

Thanks. Stephen Rothwell already reported about this bug.
see patch "mm: add config NUMA stub to all architectures"
