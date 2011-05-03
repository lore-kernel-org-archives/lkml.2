Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab1ECUJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:09:34 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:3424 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1ECUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:09:31 -0400
Subject: [PATCH 04/16] hpsa: delete old unused padding garbage
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Tue, 03 May 2011 14:59:05 -0500
Message-ID: <20110503195905.5478.38560.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa_cmd.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 1846490..0500740 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -256,14 +256,6 @@ struct ErrorInfo {
 #define CMD_IOCTL_PEND  0x01
 #define CMD_SCSI	0x03
 
-/* This structure needs to be divisible by 32 for new
- * indexing method and performant mode.
- */
-#define PAD32 32
-#define PAD64DIFF 0
-#define USEEXTRA ((sizeof(void *) - 4)/4)
-#define PADSIZE (PAD32 + PAD64DIFF * USEEXTRA)
-
 #define DIRECT_LOOKUP_SHIFT 5
 #define DIRECT_LOOKUP_BIT 0x10
 #define DIRECT_LOOKUP_MASK (~((1 << DIRECT_LOOKUP_SHIFT) - 1))

