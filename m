Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab1FINHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:07:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:33292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497Ab1FINHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:07:16 -0400
Date: Thu, 9 Jun 2011 13:07:01 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-75bba0143454d0fef1b42d5b35cb5bd2f9388901@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, benh@kernel.crashing.org, ralf@linux-mips.org,
        mattst88@gmail.com, ink@jurassic.park.msu.ru, tglx@linutronix.de,
        rth@twiddle.net
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        ralf@linux-mips.org, mattst88@gmail.com, ink@jurassic.park.msu.ru,
        tglx@linutronix.de, rth@twiddle.net
In-Reply-To: <20110601180610.684557757@duck.linux-mips.net>
References: <20110601180610.684557757@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] i8253: Alpha, PowerPC: Remove unused asm/8253pit.h
Git-Commit-ID: 75bba0143454d0fef1b42d5b35cb5bd2f9388901
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 13:07:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75bba0143454d0fef1b42d5b35cb5bd2f9388901
Gitweb:     http://git.kernel.org/tip/75bba0143454d0fef1b42d5b35cb5bd2f9388901
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:05:05 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 15:01:39 +0200

i8253: Alpha, PowerPC: Remove unused asm/8253pit.h

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/20110601180610.684557757@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/alpha/include/asm/8253pit.h   |    3 ---
 arch/powerpc/include/asm/8253pit.h |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/include/asm/8253pit.h b/arch/alpha/include/asm/8253pit.h
deleted file mode 100644
index a71c9c1..0000000
--- a/arch/alpha/include/asm/8253pit.h
+++ /dev/null
@@ -1,3 +0,0 @@
-/*
- * 8253/8254 Programmable Interval Timer
- */
diff --git a/arch/powerpc/include/asm/8253pit.h b/arch/powerpc/include/asm/8253pit.h
deleted file mode 100644
index a71c9c1..0000000
--- a/arch/powerpc/include/asm/8253pit.h
+++ /dev/null
@@ -1,3 +0,0 @@
-/*
- * 8253/8254 Programmable Interval Timer
- */
