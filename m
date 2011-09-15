Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab1IONVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:21:19 -0400
Received: from mxout1.idt.com ([157.165.5.25]:36399 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125Ab1IONVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:21:18 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Liu Gang <Gang.Liu@freescale.com>
Subject: [PATCH] RapidIO: documentation update
Date: Thu, 15 Sep 2011 09:19:19 -0400
Message-Id: <1316092759-5460-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update rapidio.txt to reflect changes from recent patch.
See http://marc.info/?l=linux-kernel&m=131285620113589&w=2 for details.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Liu Gang <Gang.Liu@freescale.com>
---
 Documentation/rapidio/rapidio.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/rapidio/rapidio.txt b/Documentation/rapidio/rapidio.txt
index be70ee1..c75694b 100644
--- a/Documentation/rapidio/rapidio.txt
+++ b/Documentation/rapidio/rapidio.txt
@@ -144,7 +144,7 @@ and the default device ID in order to access the device on the active port.
 
 After the host has completed enumeration of the entire network it releases
 devices by clearing device ID locks (calls rio_clear_locks()). For each endpoint
-in the system, it sets the Master Enable bit in the Port General Control CSR
+in the system, it sets the Discovered bit in the Port General Control CSR
 to indicate that enumeration is completed and agents are allowed to execute
 passive discovery of the network.
 
-- 
1.7.6

