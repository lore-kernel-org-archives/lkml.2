Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1DRQkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:40:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:39525 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1DRQkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:40:07 -0400
Date: Mon, 18 Apr 2011 16:39:56 GMT
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Message-ID: <tip-af289bfe15fc92ecfbf6d8312713815b33e452c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joerg.roedel@amd.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, tglx@linutronix.de
In-Reply-To: <1303134346-5805-3-git-send-email-joerg.roedel@amd.com>
References: <1303134346-5805-3-git-send-email-joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, gart: Convert spaces to tabs in enable_gart_translation
Git-Commit-ID: af289bfe15fc92ecfbf6d8312713815b33e452c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Apr 2011 16:39:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af289bfe15fc92ecfbf6d8312713815b33e452c0
Gitweb:     http://git.kernel.org/tip/af289bfe15fc92ecfbf6d8312713815b33e452c0
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Mon, 18 Apr 2011 15:45:44 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 18 Apr 2011 09:26:48 -0700

x86, gart: Convert spaces to tabs in enable_gart_translation

Probably by copy&paste this function was indented by spaces.
Convert this to tabs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1303134346-5805-3-git-send-email-joerg.roedel@amd.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/gart.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 43085bf..88c1ebe 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -75,17 +75,17 @@ static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
 {
 	u32 tmp, ctl;
 
-        /* address of the mappings table */
-        addr >>= 12;
-        tmp = (u32) addr<<4;
-        tmp &= ~0xf;
-        pci_write_config_dword(dev, AMD64_GARTTABLEBASE, tmp);
-
-        /* Enable GART translation for this hammer. */
-        pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
-        ctl |= GARTEN;
-        ctl &= ~(DISGARTCPU | DISGARTIO);
-        pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
+	/* address of the mappings table */
+	addr >>= 12;
+	tmp = (u32) addr<<4;
+	tmp &= ~0xf;
+	pci_write_config_dword(dev, AMD64_GARTTABLEBASE, tmp);
+
+	/* Enable GART translation for this hammer. */
+	pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
+	ctl |= GARTEN;
+	ctl &= ~(DISGARTCPU | DISGARTIO);
+	pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 }
 
 static inline int aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
