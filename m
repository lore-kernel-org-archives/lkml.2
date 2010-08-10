Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab0HJVor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:44:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58761 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab0HJVoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:44:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6070"; a="50561413"
Subject: Re: [GIT PULL] Initial Tegra ARM support
From: Daniel Walker <dwalker@codeaurora.org>
To: torvalds@linux-foundation.org
Cc: Erik Gilling <konkers@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org, davidb@codeaurora.org
In-Reply-To: <AANLkTi=dcQrik=+5xfwbNo_w7WkTOKZiKAFYFhwzbS=_@mail.gmail.com>
References: <AANLkTi=dcQrik=+5xfwbNo_w7WkTOKZiKAFYFhwzbS=_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 14:44:24 -0700
Message-ID: <1281476664.9400.36.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 14:10 -0700, Erik Gilling wrote:
> Hi Linus,
> 
> The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
>   Linus Torvalds (1):
>         Linux 2.6.35
> 
> are available in the git repository at:
> 
>   git://android.kernel.org/kernel/tegra.git for-linus
> 
> This code has received review on linux-arm-kernel and has been in
> for-next since June 18th.  No subsystems were harmed out side of
> mach-tegra.
> 
> Colin Cross (4):
>       [ARM] tegra: Add clock support
>       [ARM] tegra: SMP support


This fixes some typos in the Tegra tree which caused build failures in
all ARM compiles.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 arch/arm/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0ca4a94..a5d4dae 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1188,8 +1188,8 @@ config LOCAL_TIMERS
 		REALVIEW_EB_A9MP || MACH_REALVIEW_PBX || ARCH_OMAP4 || \
 		ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_TEGRA)
 	default y
-	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_VEXPRESS || ARCH_OMAP4 || \\
-		ARCH_U8500 || ARCH_TEGRA
+	select HAVE_ARM_TWD if (ARCH_REALVIEW || ARCH_VEXPRESS || ARCH_OMAP4 || \
+		ARCH_U8500 || ARCH_TEGRA)
 	help
 	  Enable support for local timers on SMP platforms, rather then the
 	  legacy IPI broadcast method.  Local timers allows the system
-- 
1.7.0.4




-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

