Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab1FVA5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:57:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11372 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493Ab1FVA5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:57:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=b4t8YF2+Cl2c85BPyHAXDTroLrZ4qMbywfqzJ0NtURAdfKsImRIJrhE4Irch7uoXR1
         WU8v3d0nTKfUuedd4tzA==
Date: Tue, 21 Jun 2011 17:56:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Len Brown <lenb@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] acpi: remove NID_INVAL
Message-ID: <alpine.DEB.2.00.1106211756110.4454@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

b552a8c56db8 ("ACPI: remove NID_INVAL") removed the left over uses of
NID_INVAL, but didn't actually remove the definition.  Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/acpi.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -238,7 +238,6 @@ extern int acpi_paddr_to_node(u64 start_addr, u64 size);
 extern int pnpacpi_disabled;
 
 #define PXM_INVAL	(-1)
-#define NID_INVAL	(-1)
 
 int acpi_check_resource_conflict(const struct resource *res);
 
