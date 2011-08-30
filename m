Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1H3ESo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:18:44 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49060 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1H3ESk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:18:40 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v3 08/18] Staging: cx25821: Fix too long lines in cx25821-audio.h
Date: Tue, 30 Aug 2011 12:17:03 +0800
Message-Id: <1314677833-4689-9-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix too long lines in cx25821-audio.h

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio.h b/drivers/staging/cx25821/cx25821-audio.h
index 2771725..a2098fb 100644
--- a/drivers/staging/cx25821/cx25821-audio.h
+++ b/drivers/staging/cx25821/cx25821-audio.h
@@ -36,13 +36,15 @@
  */
 #ifndef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
-	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE*4)
+	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + \
+	RISC_WRITECR_INSTRUCTION_SIZE*4)
 #endif
 
 /* MAE 12 July 2005 Try to use NOOP RISC instruction instead */
 #ifdef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
-	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_NOOP_INSTRUCTION_SIZE*4)
+	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + \
+	RISC_NOOP_INSTRUCTION_SIZE*4)
 #endif
 
 /* Sizes of various instructions in bytes.  Used when adding instructions. */
-- 
1.7.0.4

