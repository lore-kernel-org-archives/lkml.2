Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab2D3Tw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 15:52:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62465 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab2D3TwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 15:52:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] Move most arches to asm-generic/current.h
Date: Mon, 30 Apr 2012 19:52:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
References: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org> <201204301638.29398.arnd@arndb.de> <4F9EC6E9.9000102@codeaurora.org>
In-Reply-To: <4F9EC6E9.9000102@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301952.17755.arnd@arndb.de>
X-Provags-ID: V02:K0:Q2a4jVf84aIpZM+VNcZajlCB2KKpPtm6XiazKcndxLi
 TYNB4H8YizQwKBd4ubIXMJp7ZOEfoXiFUFm0WiaR/xuEzMmLc7
 aLOYfUZpRVSoy7dWCVHfYM4lack98C5I2plaIjFDvt340tv5rO
 6UvzBmrHByH27SkyRPp6ztOjRsEBE7wkjSizFYtbikTENLjCN0
 sluSOAZjTbjLAggxu5fevl+qs7+nRwmkIbNV7paelJBH898w7w
 xhnhhsyoCgocpLCDOmKvcQ2Bh3q/XKshPSb786PqUz8QLr3irl
 JhdmL4OVs6TRnfP3H29tbDd/2AoEm0x4RuLlFXsWoj3Zb5IMI1
 S+/BPG/t6/aXyeFpNwfk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2012, Stephen Boyd wrote:
> My compile of
> alpha with the kernel.org 4.6.3 compilers doesn't show any new build
> failures than what is already there:
> 
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `ide_set_disk_chs':
> drivers/ide/ide.c:269:(.text+0x732a8): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:269:(.text+0x732b0): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:267:(.text+0x73310): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:267:(.text+0x73318): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/built-in.o: In function `ide_dev_apply_params':
> drivers/ide/ide.c:299:(.text+0x73714): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:303:(.text+0x73724): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:308:(.text+0x73734): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide.c:315:(.text+0x73744): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/built-in.o: In function `unexpected_intr':
> drivers/ide/ide-io.c:734:(.text+0x74dfc): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide-io.c:736:(.text+0x74e00): relocation truncated to fit: GPREL16 against `.sbss'
> drivers/ide/ide-io.c:734:(.text+0x74e10): additional relocation overflows omitted from the output
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2
> 

Ok, if you were hitting the problem that I remember, you would not get
anything to build at all.

	Arnd
