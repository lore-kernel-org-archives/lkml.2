Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab0EAOj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:39:26 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:64382 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab0EAOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:38:33 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Nathan Lynch <ntl@pobox.com>,
       linuxppc-dev@ozlabs.org
Subject: [PATCH v21 088/100] powerpc: enable checkpoint support in Kconfig
Date: Sat,  1 May 2010 10:16:10 -0400
Message-Id: <1272723382-19470-89-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

Cc: linuxppc-dev@ozlabs.org
Signed-off-by: Nathan Lynch <ntl@pobox.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
---
 arch/powerpc/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2e19500..16416b0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -26,6 +26,9 @@ config MMU
 	bool
 	default y
 
+config CHECKPOINT_SUPPORT
+	def_bool y
+
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
-- 
1.6.3.3

