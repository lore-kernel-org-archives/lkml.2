Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2FDBEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:04:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59047 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab2FDBEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:04:53 -0400
Date: Sun, 03 Jun 2012 21:04:47 -0400 (EDT)
Message-Id: <20120603.210447.2167973681358303470.davem@davemloft.net>
To: sam@ravnborg.org
Cc: srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        yong.zhang0@gmail.com, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        vapier@gentoo.org, konrad@gaisler.com, tkhai@yandex.ru,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc32: refactor smp boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120603211752.GA7594@merkur.ravnborg.org>
References: <20120602162340.GA27530@merkur.ravnborg.org>
	<4FCA40A5.3060409@linux.vnet.ibm.com>
	<20120603211752.GA7594@merkur.ravnborg.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 3 Jun 2012 23:17:52 +0200

> From 531d9c538fc60c15363890768ea416897853d6af Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sun, 3 Jun 2012 23:08:18 +0200
> Subject: [PATCH] sparc32: refactor smp boot
> 
> Introduce a common smp_callin() function to call
> from trampoline_32.S.
> Add platform specific functions to handle the
> platform details.
> 
> This is in preparation for a patch that will
> unify the smp boot stuff for all architectures.
> sparc32 was significantly different to warrant
> this patch in preparation.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Acked-by: David S. Miller <davem@davemloft.net>
