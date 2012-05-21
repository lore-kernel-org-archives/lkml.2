Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2EUJ0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:26:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333Ab2EUJ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:26:44 -0400
Date: Mon, 21 May 2012 02:26:14 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-22bc48f986d21d0a8d80a642c7c4e87c11f42a5d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gxt@mprc.pku.edu.cn, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, gxt@mprc.pku.edu.cn, anna-maria@glx-um.de
In-Reply-To: <20120518163107.383567224@glx-um.de>
References: <20120518163107.383567224@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] unicore32: Use generic time config
Git-Commit-ID: 22bc48f986d21d0a8d80a642c7c4e87c11f42a5d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:26:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22bc48f986d21d0a8d80a642c7c4e87c11f42a5d
Gitweb:     http://git.kernel.org/tip/22bc48f986d21d0a8d80a642c7c4e87c11f42a5d
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:55 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:44 +0200

unicore32: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Link: http://lkml.kernel.org/r/20120518163107.383567224@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/unicore32/Kconfig |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index eeb8054..a25ca76 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -25,9 +25,6 @@ config HAVE_PWM
 config GENERIC_GPIO
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	bool
-
 config GENERIC_CSUM
 	def_bool y
 
