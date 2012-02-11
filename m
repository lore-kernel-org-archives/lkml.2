Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2BKWyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 17:54:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56421 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab2BKWyW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 17:54:22 -0500
Message-ID: <1329000863.325.54.camel@deadeye>
Subject: [PATCH 3/5] intel_idle: Fix ID for Nehalem-EX Xeon in device ID
 table
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org
Date: Sat, 11 Feb 2012 22:54:23 +0000
In-Reply-To: <1329000256.325.48.camel@deadeye>
References: <1329000256.325.48.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b66b8b9a4a79087dde1b358a016e5c8739ccf186 ('intel-idle: convert
to x86_cpu_id auto probing') put two entries for model 0x2f
(Westmere-EX Xeon) in the device ID table and left out model 0x2e
(Nehalem-EX Xeon).

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/idle/intel_idle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 237fe57..a238649 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -360,7 +360,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
 	ICPU(0x1f, idle_cpu_nehalem),
 	ICPU(0x25, idle_cpu_westmere),
 	ICPU(0x2c, idle_cpu_westmere),
-	ICPU(0x2f, idle_cpu_westmere),
+	ICPU(0x2e, idle_cpu_westmere),
 	ICPU(0x1c, idle_cpu_atom),
 	ICPU(0x26, idle_cpu_lincroft),
 	ICPU(0x2f, idle_cpu_westmere),
-- 
1.7.9



