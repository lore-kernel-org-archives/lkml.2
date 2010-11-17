Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733Ab0KQMbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:31:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:52924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744Ab0KQMbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:31:24 -0500
Date: Wed, 17 Nov 2010 12:30:57 GMT
From: tip-bot for Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, randy.dunlap@oracle.com,
        alan@lxorguk.ukuu.org.uk
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, randy.dunlap@oracle.com
In-Reply-To: <20101115173110.6877.83958.stgit@localhost.localdomain>
References: <20101115173110.6877.83958.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, mrst: The shutdown for MRST requires the SCU IPC mechanism
Message-ID: <tip-b9fc71f47dc060c588e5099638242fad44eeecbc@git.kernel.org>
Git-Commit-ID: b9fc71f47dc060c588e5099638242fad44eeecbc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Nov 2010 12:30:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9fc71f47dc060c588e5099638242fad44eeecbc
Gitweb:     http://git.kernel.org/tip/b9fc71f47dc060c588e5099638242fad44eeecbc
Author:     Alan Cox <alan@lxorguk.ukuu.org.uk>
AuthorDate: Mon, 15 Nov 2010 17:31:19 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 17 Nov 2010 13:27:44 +0100

x86, mrst: The shutdown for MRST requires the SCU IPC mechanism

Fix the build failure reported by Randy.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
LKML-Reference: <20101115173110.6877.83958.stgit@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e5510cf..6e877b9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -399,6 +399,7 @@ config X86_MRST
 	select APB_TIMER
 	select I2C
 	select SPI
+	select INTEL_SCU_IPC
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:
