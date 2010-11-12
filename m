Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab0KLVlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:41:16 -0500
Received: from kroah.org ([198.145.64.141]:41588 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026Ab0KLVlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/19] tty: Fix formatting in tty.h
Date: Fri, 12 Nov 2010 13:40:49 -0800
Message-Id: <1289598066-10112-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Someone added a new ldisc number and messed up the tabbing. Fix it before
anyone else copies it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/tty.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 2a75474..c7ea9bc 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -50,7 +50,7 @@
 #define N_V253		19	/* Codec control over voice modem */
 #define N_CAIF		20      /* CAIF protocol for talking to modems */
 #define N_GSM0710	21	/* GSM 0710 Mux */
-#define N_TI_WL	22	/* for TI's WL BT, FM, GPS combo chips */
+#define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
 
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as
-- 
1.7.1

