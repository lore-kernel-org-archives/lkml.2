Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab0E0Vw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:52:59 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60494 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab0E0Vw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:52:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5995"; a="42640430"
Subject: [GIT PULL] ARM MSM updates for 2.6.35-rc1
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 14:52:53 -0700
Message-ID: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a couple of simple patches. One fixes a compile failure in
certain situations, and the other is just dead code removal.

Daniel


The following changes since commit 7b52161d14fa8a22a2387f4aa2fb7b854587830d:

  msm: 7x30 Kconfig and makefile changes (2010-05-13 16:08:55 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-core

Daniel Walker (1):
      msm: dma: add completion.h header

Huang Weiyi (1):
      arm: msm: remove unused #include <linux/version.h>

 arch/arm/mach-msm/acpuclock-arm11.c |    1 -
 arch/arm/mach-msm/clock.c           |    1 -
 arch/arm/mach-msm/dma.c             |    1 +
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/acpuclock-arm11.c b/arch/arm/mach-msm/acpuclock-arm11.c
index af5e85b..6ca42fd 100644
--- a/arch/arm/mach-msm/acpuclock-arm11.c
+++ b/arch/arm/mach-msm/acpuclock-arm11.c
@@ -17,7 +17,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/list.h>
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 9cb1276..c57210f 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -14,7 +14,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index 3d725ae..3db0bfe 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
+#include <linux/completion.h>
 #include <mach/dma.h>
 
 #define MSM_DMOV_CHANNEL_COUNT 16


