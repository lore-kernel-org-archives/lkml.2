Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab0IBVGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:06:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39302 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab0IBVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iICraizpAe/eW/pzxWKliB+SWyqtR53UJ/54CByFJUauqtrdCRv4ybeCwG3q2iudZO
         9hfX7NH9fnBTq7LX16y1GxS5gGg+xFZgUtCNWqO5F8UBxMhuXHAXt93+eIRhsjVyPPce
         t4SjIj0qmxMONhgdm+1wST0/k1qFc1DRzymTE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 01/91] arch/alpha/kernel/sys_sio.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:06:32 -0700
Message-Id: <1283461606-7803-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
References: <1283461606-7803-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/alpha/kernel/sys_sio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
index 85b4aea..7d79037 100644
--- a/arch/alpha/kernel/sys_sio.c
+++ b/arch/alpha/kernel/sys_sio.c
@@ -154,8 +154,8 @@ noname_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
 	 * bridge (PIRQ0-PIRQ3).  The table below is based on
 	 * information available at:
 	 *
-	 *   http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt
-	 *
+	 *  http://web.archive.org/web/*/http://ftp.digital.com/pub/ 
+	 *  DEC/axppci/ref_interrupts.txt
 	 * I have no information on the Avanti interrupt routing, but
 	 * the routing seems to be identical to the Noname except
 	 * that the Avanti has an additional slot whose routing I'm
-- 
1.7.2.1

