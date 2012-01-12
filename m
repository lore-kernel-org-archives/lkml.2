Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2ALUwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:52:38 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:40450
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755549Ab2ALUwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:52:35 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 13/15] Staging: hv: storvsc: Get rid of some unused defines
Date: Thu, 12 Jan 2012 12:38:06 -0800
Message-Id: <1326400688-13544-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1326400688-13544-1-git-send-email-kys@microsoft.com>
References: <1326400637-13494-1-git-send-email-kys@microsoft.com>
 <1326400688-13544-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some unused defines.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 9f07458..d34e3ca 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -81,18 +81,6 @@ static inline u16 storvsc_get_version(u8 major, u8 minor)
 #define VMSTOR_CURRENT_MINOR  2
 
 
-/*
- * This will get replaced with the max transfer length that is possible on
- * the host adapter.
- * The max transfer length will be published when we offer a vmbus channel.
- */
-
-#define MAX_TRANSFER_LENGTH	0x40000
-#define DEFAULT_PACKET_SIZE (sizeof(struct vmdata_gpa_direct) +	\
-			sizeof(struct vstor_packet) +		\
-			sizesizeof(u64) * (MAX_TRANSFER_LENGTH / PAGE_SIZE)))
-
-
 /*  Packet structure describing virtual storage requests. */
 enum vstor_packet_operation {
 	VSTOR_OPERATION_COMPLETE_IO		= 1,
-- 
1.7.4.1

