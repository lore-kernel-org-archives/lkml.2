Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1GWPAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 11:00:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:56109 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab1GWPAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 11:00:40 -0400
Date: Sat, 23 Jul 2011 17:00:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Juergen Beisert <jbe@pengutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt1
In-Reply-To: <201107231629.25322.jbe@pengutronix.de>
Message-ID: <alpine.LFD.2.02.1107231659420.2702@ionos>
References: <alpine.LFD.2.02.1107222203400.2702@ionos> <201107231629.25322.jbe@pengutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011, Juergen Beisert wrote:

> Hi Thomas,
> 
> on ARM (in this case a Samsung S3C2440 based platform) I get:
> 
> kernel/built-in.o: In function `vprintk':
> /home/jb/[...]/linux-3.0/kernel/printk.c:862: undefined reference to `early_vprintk'
> kernel/built-in.o: In function `register_console':
> /home/jb/[...]linux-3.0/kernel/printk.c:1580: undefined reference to `early_console_initialized'
> make[1]: *** [vmlinux] Error 1
> 
> Did I forget something to enable in my kernel config?

No, that's my fault. I merged a late minute debugfeature yesterday and
forgot to enable early_printk on ARM. Will be fixed in -rt2 which i'm
about to release.

Thanks,

	tglx
