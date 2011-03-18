Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab1CRMqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:46:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:59841 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab1CRMqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:46:25 -0400
Date: Fri, 18 Mar 2011 12:46:02 GMT
From: tip-bot for Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        lucas.de.marchi@gmail.com, tglx@linutronix.de,
        lucas.demarchi@profusion.mobi, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lucas.de.marchi@gmail.com, tglx@linutronix.de,
        lucas.demarchi@profusion.mobi, mingo@elte.hu
In-Reply-To: <1300389856-1099-2-git-send-email-lucas.demarchi@profusion.mobi>
References: <1300389856-1099-2-git-send-email-lucas.demarchi@profusion.mobi>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix misspelling and align params
Message-ID: <tip-a6c3270b04340c5e0d47af5bdb10f30d33333739@git.kernel.org>
Git-Commit-ID: a6c3270b04340c5e0d47af5bdb10f30d33333739
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Mar 2011 12:46:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6c3270b04340c5e0d47af5bdb10f30d33333739
Gitweb:     http://git.kernel.org/tip/a6c3270b04340c5e0d47af5bdb10f30d33333739
Author:     Lucas De Marchi <lucas.de.marchi@gmail.com>
AuthorDate: Thu, 17 Mar 2011 16:24:15 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Mar 2011 10:39:30 +0100

x86: Fix misspelling and align params

Fix 'upto' misspelling and align parameters.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: trivial@kernel.org
LKML-Reference: <1300389856-1099-2-git-send-email-lucas.demarchi@profusion.mobi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/x86/x86_64/boot-options.txt |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 7fbbaf8..48c13b8 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -189,13 +189,13 @@ ACPI
 
 PCI
 
-  pci=off	Don't use PCI
-  pci=conf1	Use conf1 access.
-  pci=conf2	Use conf2 access.
-  pci=rom	Assign ROMs.
-  pci=assign-busses    Assign busses
-  pci=irqmask=MASK	       Set PCI interrupt mask to MASK
-  pci=lastbus=NUMBER	       Scan upto NUMBER busses, no matter what the mptable says.
+  pci=off		Don't use PCI
+  pci=conf1		Use conf1 access.
+  pci=conf2		Use conf2 access.
+  pci=rom		Assign ROMs.
+  pci=assign-busses	Assign busses
+  pci=irqmask=MASK	Set PCI interrupt mask to MASK
+  pci=lastbus=NUMBER	Scan up to NUMBER busses, no matter what the mptable says.
   pci=noacpi		Don't use ACPI to set up PCI interrupt routing.
 
 IOMMU (input/output memory management unit)
