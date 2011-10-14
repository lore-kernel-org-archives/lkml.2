Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab1JNM1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:27:35 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57660 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1JNM1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:27:34 -0400
Subject: [PATCH 01/21] alpha: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:27:20 +0200
Message-ID: <1318595240.6132.57.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/alpha/Kconfig |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 8bb9362..3d74801 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -445,11 +445,6 @@ config ALPHA_EV67
 	  Is this a machine based on the EV67 core?  If in doubt, select N here
 	  and the machine will be treated as an EV6.
 
-config ALPHA_EV7
-	bool
-	depends on ALPHA_MARVEL
-	default y
-
 config ALPHA_MCPCIA
 	bool
 	depends on ALPHA_RAWHIDE
-- 
1.7.4.4




