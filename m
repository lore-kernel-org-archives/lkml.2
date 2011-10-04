Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab1JDQvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:51:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932824Ab1JDQoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:44:14 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH v4 03/24] add ELF machine define for TI C6X DSPs
Date: Tue,  4 Oct 2011 12:43:40 -0400
Message-Id: <1317746641-26725-4-git-send-email-msalter@redhat.com>
In-Reply-To: <1317746641-26725-1-git-send-email-msalter@redhat.com>
References: <1317746641-26725-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/elf-em.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/elf-em.h b/include/linux/elf-em.h
index 18bea78..8e2b7ba 100644
--- a/include/linux/elf-em.h
+++ b/include/linux/elf-em.h
@@ -33,6 +33,7 @@
 #define EM_H8_300	46	/* Renesas H8/300,300H,H8S */
 #define EM_MN10300	89	/* Panasonic/MEI MN10300, AM33 */
 #define EM_BLACKFIN     106     /* ADI Blackfin Processor */
+#define EM_TI_C6000	140	/* TI C6X DSPs */
 #define EM_FRV		0x5441	/* Fujitsu FR-V */
 #define EM_AVR32	0x18ad	/* Atmel AVR32 */
 
-- 
1.7.6.2

