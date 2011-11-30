Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab1K3KSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 05:18:21 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38589 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1K3KSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 05:18:18 -0500
Message-ID: <1322648286.6774.0.camel@phoenix>
Subject: [PATCH] NFC: pn533: Staticise pn533_data_exchange()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 30 Nov 2011 18:18:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used outside this driver so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/nfc/pn533.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index bd02384..ea10f54 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1339,7 +1339,7 @@ error:
 	return 0;
 }
 
-int pn533_data_exchange(struct nfc_dev *nfc_dev, u32 target_idx,
+static int pn533_data_exchange(struct nfc_dev *nfc_dev, u32 target_idx,
 						struct sk_buff *skb,
 						data_exchange_cb_t cb,
 						void *cb_context)
-- 
1.7.5.4



