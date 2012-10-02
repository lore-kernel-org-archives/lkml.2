Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2JBPaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:30:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2JBPao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:30:44 -0400
Message-ID: <1349191833.14338.1.camel@phoenix>
Subject: [PATCH] extcon: Fix kerneldoc for extcon_set_cable_state and
 extcon_set_cable_state_
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 02 Oct 2012 23:30:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/extcon/extcon-class.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 946a318..337bbb4 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -362,7 +362,7 @@ int extcon_get_cable_state(struct extcon_dev *edev, const char *cable_name)
 EXPORT_SYMBOL_GPL(extcon_get_cable_state);
 
 /**
- * extcon_get_cable_state_() - Set the status of a specific cable.
+ * extcon_set_cable_state_() - Set the status of a specific cable.
  * @edev:	the extcon device that has the cable.
  * @index:	cable index that can be retrieved by extcon_find_cable_index().
  * @cable_state:	the new cable status. The default semantics is
@@ -382,7 +382,7 @@ int extcon_set_cable_state_(struct extcon_dev *edev,
 EXPORT_SYMBOL_GPL(extcon_set_cable_state_);
 
 /**
- * extcon_get_cable_state() - Set the status of a specific cable.
+ * extcon_set_cable_state() - Set the status of a specific cable.
  * @edev:	the extcon device that has the cable.
  * @cable_name:	cable name.
  * @cable_state:	the new cable status. The default semantics is
-- 
1.7.9.5



