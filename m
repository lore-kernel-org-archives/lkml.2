Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006Ab0JZPxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:53:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45992
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543Ab0JZPxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:53:15 -0400
Date: Tue, 26 Oct 2010 08:53:38 -0700 (PDT)
Message-Id: <20101026.085338.104057457.davem@davemloft.net>
To: namhyung@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc32: make CONFIG_SPARC_LEON depends on !SMP to fix
 build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288108303-2712-1-git-send-email-namhyung@gmail.com>
References: <1288108303-2712-1-git-send-email-namhyung@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>
Date: Wed, 27 Oct 2010 00:51:43 +0900

>   CC      arch/sparc/kernel/irq_32.o
> arch/sparc/kernel/irq_32.c: In function 'request_fast_irq':
> arch/sparc/kernel/irq_32.c:370:25: error: conflicting types for 'trapbase_cpu1'
> arch/sparc/include/asm/leon.h:366:22: note: previous declaration of 'trapbase_cpu1' was here
> arch/sparc/kernel/irq_32.c:370:40: error: conflicting types for 'trapbase_cpu2'
> arch/sparc/include/asm/leon.h:367:22: note: previous declaration of 'trapbase_cpu2' was here
> arch/sparc/kernel/irq_32.c:370:55: error: conflicting types for 'trapbase_cpu3'
> arch/sparc/include/asm/leon.h:368:22: note: previous declaration of 'trapbase_cpu3' was here
> make[3]: *** [arch/sparc/kernel/irq_32.o] Error 1
> make[2]: *** [arch/sparc/kernel] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Great, I'll apply all three of your patches thanks.
