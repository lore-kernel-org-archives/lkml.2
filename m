Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab2CXH5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:57:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2CXH5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:57:51 -0400
Date: Sat, 24 Mar 2012 00:57:41 -0700
From: tip-bot for Randy Dunlap <rdunlap@xenotime.net>
Message-ID: <tip-f5243d6de7ae232e1d81e44ae9756bbd8c988fcd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rdunlap@xenotime.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rdunlap@xenotime.net
In-Reply-To: <4F6D05CA.2050801@xenotime.net>
References: <4F6D05CA.2050801@xenotime.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/kconfig: Remove CONFIG_TR=
 y from the defconfigs
Git-Commit-ID: f5243d6de7ae232e1d81e44ae9756bbd8c988fcd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 24 Mar 2012 00:57:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5243d6de7ae232e1d81e44ae9756bbd8c988fcd
Gitweb:     http://git.kernel.org/tip/f5243d6de7ae232e1d81e44ae9756bbd8c988fcd
Author:     Randy Dunlap <rdunlap@xenotime.net>
AuthorDate: Fri, 23 Mar 2012 16:22:50 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 24 Mar 2012 08:18:03 +0100

x86/kconfig: Remove CONFIG_TR=y from the defconfigs

Remove CONFIG_TR=y from the x86 defconfigs since
token ring support is antiquated and obsolete.

( I reviewed both x86 defconfigs - I didn't come up with
  anything else that obviously should be removed. )

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Link: http://lkml.kernel.org/r/4F6D05CA.2050801@xenotime.net
[ Twiddled the changelog a bit ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/configs/i386_defconfig   |    1 -
 arch/x86/configs/x86_64_defconfig |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 2d56282..119db67 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -183,7 +183,6 @@ CONFIG_8139TOO=y
 # CONFIG_8139TOO_PIO is not set
 CONFIG_R8169=y
 CONFIG_FDDI=y
-CONFIG_TR=y
 CONFIG_INPUT_POLLDEV=y
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 3cf137a..76eb290 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -176,7 +176,6 @@ CONFIG_SKY2=y
 CONFIG_FORCEDETH=y
 CONFIG_8139TOO=y
 CONFIG_FDDI=y
-CONFIG_TR=y
 CONFIG_INPUT_POLLDEV=y
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y
