Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab1EFK4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:56:51 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:41436
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153Ab1EFKye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:34 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 08/16] staging: usbip: stub.h: coding style cleanup
Date: Fri,  6 May 2011 03:47:48 -0700
Message-Id: <70fd590bd9756fe52331f7efbe5250310fa5cea7.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extraneous lines.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
index 6004fcd..6d252b8 100644
--- a/drivers/staging/usbip/stub.h
+++ b/drivers/staging/usbip/stub.h
@@ -58,7 +58,6 @@ struct stub_device {
 	struct list_head unlink_tx;
 	struct list_head unlink_free;
 
-
 	wait_queue_head_t tx_waitq;
 };
 
@@ -89,7 +88,6 @@ struct bus_id_priv {
 
 extern struct kmem_cache *stub_priv_cache;
 
-
 /*-------------------------------------------------------------------------*/
 /* prototype declarations */
 
-- 
1.7.5.1

