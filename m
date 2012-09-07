Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2IGTxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:53:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab2IGTxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:53:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 28/31] arm64: Generic timers support
Date: Fri, 7 Sep 2012 19:53:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-29-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-29-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071953.14680.arnd@arndb.de>
X-Provags-ID: V02:K0:4YYmhT8crGOZ3uF/GFZZTwL5DU/cbSghpHR2vSSLjxp
 MJYY4vt7uwz3u9lmkIg+SJL5xh+nbmsRcwxzk3zvgyXrf3s2n7
 Ii48tLHfyimbQ7VsRWFB7iuO2bcI9ggrK73T3er8iRkLsuVQOz
 g8jtNtdNiYi+PZp5XPSgMDf0P7rJFn0WFs/Co9AxCTgDbM6jI6
 z3jR1C9helni7Vi2QfQNi9+Ueq6oBje3QhhQMeDUhJqQ/VEVHA
 7a1bCdumJJfX4IDoRtewg5Yv7Uq11cWAFjdBlpy0EoabT6j/n2
 PbwSmNCZSWRk7ZbUBeh81JlUotsxNEyj8DGthcggDz4Vg44isU
 nL9B72mm5kb8X6VRqw4A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> This patch adds support for the ARM generic timers with A64 instructions
> for accessing the timer registers. It uses the physical counter as the
> clock source and the virtual counter as sched_clock.
> 
> The timer frequency can be specified via DT or read from the CNTFRQ_EL0
> register. The physical counter is also accessible from user space
> allowing fast gettimeofday() implementation.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
