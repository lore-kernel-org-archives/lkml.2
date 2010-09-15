Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0IOOhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:37:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:41957 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab0IOOhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:37:54 -0400
Date: Wed, 15 Sep 2010 14:37:39 GMT
From: tip-bot for Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        hancockrwd@gmail.com, udovdh@xs4all.nl, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hancockrwd@gmail.com, tglx@linutronix.de, udovdh@xs4all.nl
In-Reply-To: <4C8F04DC.5060303@xs4all.nl>
References: <4C8F04DC.5060303@xs4all.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/quirks] x86: HPET force enable for CX700 / VIA Epia LT
Message-ID: <tip-892df7f81c31ce7f85778aa78094e8d1f19b8413@git.kernel.org>
Git-Commit-ID: 892df7f81c31ce7f85778aa78094e8d1f19b8413
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 14:37:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  892df7f81c31ce7f85778aa78094e8d1f19b8413
Gitweb:     http://git.kernel.org/tip/892df7f81c31ce7f85778aa78094e8d1f19b8413
Author:     Udo van den Heuvel <udovdh@xs4all.nl>
AuthorDate: Tue, 14 Sep 2010 07:15:08 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 15 Sep 2010 16:27:04 +0200

x86: HPET force enable for CX700 / VIA Epia LT

Allow using HPET with the hpet=force command line option on VIA EPIA
CX700 systems.

Signed-off-by: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: Robert Hancock <hancockrwd@gmail.com>
LKML-Reference:  <4C8F04DC.5060303@xs4all.nl>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/quirks.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 939b9e9..8bbe8c5 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -344,6 +344,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8235,
 			 vt8237_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
 			 vt8237_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700,
+			 vt8237_force_enable_hpet);
 
 static void ati_force_hpet_resume(void)
 {
