Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab0EAOix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:38:53 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:64338 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894Ab0EAOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:38:31 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Nathan Lynch <ntl@pobox.com>,
       linuxppc-dev@ozlabs.org
Subject: [PATCH v21 084/100] powerpc: reserve checkpoint arch identifiers
Date: Sat,  1 May 2010 10:16:06 -0400
Message-Id: <1272723382-19470-85-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

Changelog [v19-rc1]:
  - [Matt Helsley] Add cpp definitions for enums

Cc: linuxppc-dev@ozlabs.org
Signed-off-by: Nathan Lynch <ntl@pobox.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/checkpoint_hdr.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/checkpoint_hdr.h b/include/linux/checkpoint_hdr.h
index f2779d1..90cbc15 100644
--- a/include/linux/checkpoint_hdr.h
+++ b/include/linux/checkpoint_hdr.h
@@ -193,6 +193,10 @@ enum {
 #define CKPT_ARCH_X86_64 CKPT_ARCH_X86_64
 	CKPT_ARCH_S390X,
 #define CKPT_ARCH_S390X CKPT_ARCH_S390X
+	CKPT_ARCH_PPC32,
+#define CKPT_ARCH_PPC32 CKPT_ARCH_PPC32
+	CKPT_ARCH_PPC64,
+#define CKPT_ARCH_PPC64 CKPT_ARCH_PPC64
 };
 
 /* shared objrects (objref) */
-- 
1.6.3.3

