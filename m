Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab2CWXWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 19:22:55 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:45469 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754276Ab2CWXWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:22:53 -0400
Message-ID: <4F6D05CA.2050801@xenotime.net>
Date: Fri, 23 Mar 2012 16:22:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: [PATCH] x86: remove CONFIG_TR from defconfigs
References: <tip-ahz3d8i1vxwj0379gv4tqcru@git.kernel.org> <4F6CD38B.1010602@xenotime.net> <20120323195520.GA7222@gmail.com>
In-Reply-To: <20120323195520.GA7222@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 12:55 PM, Ingo Molnar wrote:

> 
> Yeah, now that the defconfigs are much smaller we can do such 
> things. Mind resending the patch and possibly checking all the 
> other options as well?




OK, I reviewed both x86 defconfigs.  I didn't come up with anything
else that obviously should be removed, so here is the CONFIG_TR patch.
(applies on top of your defconfig updates)

---
From: Randy Dunlap <rdunlap@xenotime.net>

Remove CONFIG_TR from defconfigs for x86 since it
is antiquated and obsolete.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/x86/configs/i386_defconfig   |    1 -
 arch/x86/configs/x86_64_defconfig |    1 -
 2 files changed, 2 deletions(-)

--- lnx-33.orig/arch/x86/configs/i386_defconfig
+++ lnx-33/arch/x86/configs/i386_defconfig
@@ -183,7 +183,6 @@ CONFIG_8139TOO=y
 # CONFIG_8139TOO_PIO is not set
 CONFIG_R8169=y
 CONFIG_FDDI=y
-CONFIG_TR=y
 CONFIG_INPUT_POLLDEV=y
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y
--- lnx-33.orig/arch/x86/configs/x86_64_defconfig
+++ lnx-33/arch/x86/configs/x86_64_defconfig
@@ -176,7 +176,6 @@ CONFIG_SKY2=y
 CONFIG_FORCEDETH=y
 CONFIG_8139TOO=y
 CONFIG_FDDI=y
-CONFIG_TR=y
 CONFIG_INPUT_POLLDEV=y
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y
