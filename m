Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab0JFQE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:04:57 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:60544 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743Ab0JFQEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:04:54 -0400
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: greg@kroah.com
Cc: Scott.Kilau@digi.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: [PATCH] MAINTAINERS: add drivers/serial/jsm/ as maintained driver
Date: Wed,  6 Oct 2010 13:04:48 -0300
Message-Id: <1286381088-7614-1-git-send-email-leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soott Kilau is handing off the maintainership of the jsm serial
driver to me, and this patch just add the driver as maintained.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f46d8e6..581a2e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3309,6 +3309,12 @@ F:	fs/jbd*/
 F:	include/linux/ext*jbd*.h
 F:	include/linux/jbd*.h
 
+JSM Neo PCI based serial card
+M:	Breno Leitao <leitao@linux.vnet.ibm.com>
+L:	linux-serial@vger.kernel.org
+S:	Maintained
+F:	drivers/serial/jsm/
+
 K8TEMP HARDWARE MONITORING DRIVER
 M:	Rudolf Marek <r.marek@assembler.cz>
 L:	lm-sensors@lm-sensors.org
-- 
1.7.2.3

