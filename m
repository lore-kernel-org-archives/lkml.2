Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1DKPkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:40:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:44671 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1DKPka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:40:30 -0400
Date: Mon, 11 Apr 2011 15:40:12 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Message-ID: <tip-30d746c68025ee69ac17219aacc9b1614d951f01@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, bigeasy@linutronix.de, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de, bigeasy@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407121315.GA9204@linutronix.de>
References: <20110407121315.GA9204@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/ce4100: Add reg property to bridges
Git-Commit-ID: 30d746c68025ee69ac17219aacc9b1614d951f01
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 15:40:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30d746c68025ee69ac17219aacc9b1614d951f01
Gitweb:     http://git.kernel.org/tip/30d746c68025ee69ac17219aacc9b1614d951f01
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Thu, 7 Apr 2011 14:13:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 17:37:02 +0200

x86/ce4100: Add reg property to bridges

without the reg property Ben's new code won't find the PCI & ISA
bridge and the devices won't get the DT-node attached.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: davem@davemloft.net
Cc: monstr@monstr.eu
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: http://lkml.kernel.org/r/20110407121315.GA9204@linutronix.de
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/ce4100/falconfalls.dts |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
index dc701ea..2d6d226 100644
--- a/arch/x86/platform/ce4100/falconfalls.dts
+++ b/arch/x86/platform/ce4100/falconfalls.dts
@@ -74,6 +74,7 @@
 				compatible = "intel,ce4100-pci", "pci";
 				device_type = "pci";
 				bus-range = <1 1>;
+				reg = <0x0800 0x0 0x0 0x0 0x0>;
 				ranges = <0x2000000 0 0xdffe0000 0x2000000 0 0xdffe0000 0 0x1000>;
 
 				interrupt-parent = <&ioapic2>;
@@ -412,6 +413,7 @@
 				#address-cells = <2>;
 				#size-cells = <1>;
 				compatible = "isa";
+				reg = <0xf800 0x0 0x0 0x0 0x0>;
 				ranges = <1 0 0 0 0 0x100>;
 
 				rtc@70 {
