Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab0IBVXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:23:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab0IBVIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iV5lKuvnodUxnaA2E/+BgzWQMwBv2i9xUAN41dZAlAW1AEwjGvT6ThSghnoYym0c2T
         Xq7lKeNVbCmUOxvDIrcwP8EH1SFknVh5WCWCWRk+oOQT+cwe/yaziJDN7v1CRs4fA9wo
         oyPUD8JN7wFQM2ls7njESn4/NyjH7dqKLhe4E=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 22/91] arch/arm/mm/proc-xscale.S Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:51 -0700
Message-Id: <1283461679-7851-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
References: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/mm/proc-xscale.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index 1407597..887975f 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -418,7 +418,7 @@ ENTRY(xscale_cache_fns)
  *
  * See erratum #25 of "Intel 80200 Processor Specification Update",
  * revision January 22, 2003, available at:
- *     http://www.intel.com/design/iio/specupdt/273415.htm
+ *     http://www.intel.com/design/
  */
 ENTRY(xscale_80200_A0_A1_cache_fns)
 	.long	xscale_flush_kern_cache_all
-- 
1.7.2.1

