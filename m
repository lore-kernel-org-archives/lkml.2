Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1HZAb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:31:27 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57339 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1HZAbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:31:25 -0400
MIME-Version: 1.0
Date: Fri, 26 Aug 2011 09:31:25 +0900
Message-ID: <CAFWwQu_-HirBTsyFpG8EKs6Su9r=O4Wi8=L3b-O4OdMKDC0f8g@mail.gmail.com>
Subject: ARMv7 MMU and cache enabling code in boot/compressed/head.S
From: Moon Hwa Hong <armkernel8@gmail.com>
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: linux@arm.linux.org.uk, sshtylyov@mvista.com, arnd@arndb.de,
        swarren@nvidia.com, marek.belisko@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        shawn.guo@freescale.com, linux-tegra@vger.kernel.org,
        jamie@jamieiles.com, linus.walleij@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I started arm linux kernel hacking.
I can't understand 554 line.
I think that 554 line is not necessary.
Because ISB instruction(556 line) makes synchronization between 553 and 557.
Please advice to me.


530 __armv7_mmu_cache_on:
.
.
.
553         mcr p15, 0, r0, c1, c0, 0   @ load control register
554         mrc p15, 0, r0, c1, c0, 0   @ and read it back
555         mov r0, #0
556         mcr p15, 0, r0, c7, c5, 4   @ ISB
557         mov pc, r12

Have a nice day.

MH Hong.
