Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab1B1JBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:01:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:38440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab1B1JBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:01:13 -0500
Date: Mon, 28 Feb 2011 09:00:57 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bigeasy@linutronix.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1298830419-22681-1-git-send-email-bigeasy@linutronix.de>
References: <1298830419-22681-1-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: dt: Correct local apic documentation in device tree bindings
Message-ID: <tip-a56ec98357ad26b380f1005198de1aa519c9e9cb@git.kernel.org>
Git-Commit-ID: a56ec98357ad26b380f1005198de1aa519c9e9cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Feb 2011 09:00:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a56ec98357ad26b380f1005198de1aa519c9e9cb
Gitweb:     http://git.kernel.org/tip/a56ec98357ad26b380f1005198de1aa519c9e9cb
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Sun, 27 Feb 2011 19:13:39 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 28 Feb 2011 09:58:06 +0100

x86: dt: Correct local apic documentation in device tree bindings

Until "x86: dt: Cleanup local apic setup" we read the local apic
address from the MSR and ignored the entry in DT. Reflect this change
in the documentation.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
LKML-Reference: <1298830419-22681-1-git-send-email-bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 .../devicetree/bindings/x86/interrupt.txt          |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/x86/interrupt.txt b/Documentation/devicetree/bindings/x86/interrupt.txt
index 8b0efb0..7d19f49 100644
--- a/Documentation/devicetree/bindings/x86/interrupt.txt
+++ b/Documentation/devicetree/bindings/x86/interrupt.txt
@@ -24,6 +24,3 @@ Interrupt chips
   Required property:
 
      compatible = "intel,ce4100-lapic";
-
-  This node is currently unused by Linux as the address of the local APIC
-  read from a MSR.
