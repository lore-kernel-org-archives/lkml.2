Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1CQTYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:24:22 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46184 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab1CQTYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YsCL7yOgQ6B4VtDFPL5EShiw8Kp78gbuUrkMxOwhwFTQF1a5TynmNgf1qj1ynzIaS9
         knBTmlVciU38zJobTHrhBvB0kpl01KgC2u6SZncCWSV7BL6T0QB1Ef0PjaDcDh+RuwaB
         CqG5/vzWYBCp382kMvrLY9TtTViz1AP/X0B6Y=
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: mingo@redhat.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 1/2] x86: fix misspelling and align params
Date: Thu, 17 Mar 2011 16:24:15 -0300
Message-Id: <1300389856-1099-2-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300389856-1099-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1300389856-1099-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 'upto' misspelling and align parameters.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
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
-- 
1.7.4.1

