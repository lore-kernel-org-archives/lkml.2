Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab2BQU1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:27:54 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48391 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101Ab2BQU1x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:27:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CarXUJ1XVJMWCEt1AXvnE5Gvunou_8nydjLmPVkZERMA@mail.gmail.com>
References: <CAOMZO5CarXUJ1XVJMWCEt1AXvnE5Gvunou_8nydjLmPVkZERMA@mail.gmail.com>
Date: Fri, 17 Feb 2012 21:27:53 +0100
Message-ID: <CAFLxGvwSVq1GhSVnHyt9jKTy4cvZ4a0hQUau6Kh36fQuw9bdjQ@mail.gmail.com>
Subject: Re: ARM: __enabled_CONFIG_NUMA undeclared
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: khlebnikov@openvz.org, akpm@linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 9:12 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Hi,
>
> Building today's linux-next for ARM:
>
>  CC      arch/arm/kernel/asm-offsets.s
> In file included from include/linux/mm.h:8:0,
>                 from arch/arm/kernel/asm-offsets.c:14:
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

UML is affected too.

-- 
Thanks,
//richard
