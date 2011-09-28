Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab1I1Wm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:42:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab1I1Wmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:36 2011
Message-Id: <20110928220136.830559887@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>
Subject: [109/244] acpica: ACPI_MAX_SLEEP should be 2 sec, not 20
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Len Brown <len.brown@intel.com>

commit b33c25d6a62ac253caabda2b5f43258abff451c0 upstream.

This limit is a workaround for AML that sleeps too long,
but the workaround didn't work b/c of a typo.

https://bugzilla.kernel.org/show_bug.cgi?id=13195

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/acpica/acconfig.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/acpica/acconfig.h
+++ b/drivers/acpi/acpica/acconfig.h
@@ -121,7 +121,7 @@
 
 /* Maximum sleep allowed via Sleep() operator */
 
-#define ACPI_MAX_SLEEP                  20000	/* Two seconds */
+#define ACPI_MAX_SLEEP                  2000	/* Two seconds */
 
 /******************************************************************************
  *


