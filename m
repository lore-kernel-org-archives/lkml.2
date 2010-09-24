Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0IXGVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 02:21:45 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56896 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab0IXGVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 02:21:44 -0400
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        takedakn@nttdata.co.jp, akpm@linux-foundation.org, jmorris@namei.org
Subject: Re: Tomoyo compile failure on alpha: sys_get[p]pid undefined
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.SOC.1.00.1009240906200.9058@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1009240906200.9058@math.ut.ee>
Message-Id: <201009241521.BFC95867.LOQFFHMOFVOJtS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 24 Sep 2010 15:21:36 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos wrote:
> 2.6.36-rc5+git as of yesterday:
> 
>   LD      .tmp_vmlinux1
> security/built-in.o: In function `tomoyo_supervisor':(.text+0xea98): undefined reference to `sys_getpid'
> security/built-in.o: In function `tomoyo_supervisor':(.text+0xeab0): undefined reference to `sys_getpid'
> security/built-in.o: In function `tomoyo_supervisor':(.text+0xeac0): undefined reference to `sys_getppid'
> security/built-in.o: In function `tomoyo_supervisor':(.text+0xeac4): undefined reference to `sys_getppid'
> 
> Seems alpha has different mechanisms for using these syscalls from 
> inside the kernel?

Thank you for reporting.
I forwarded it to linux-alpha ML and waiting for response now.

http://marc.info/?l=linux-alpha&m=128530336613660&w=2

Regards.
