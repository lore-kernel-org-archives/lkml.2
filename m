Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab0JVSWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:22:13 -0400
Received: from kroah.org ([198.145.64.141]:41937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab0JVSWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:22:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Breno Leitao <leitao@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/49] tty: MAINTAINERS: add drivers/serial/jsm/ as maintained driver
Date: Fri, 22 Oct 2010 11:21:10 -0700
Message-Id: <1287771688-14805-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitao <leitao@linux.vnet.ibm.com>

Soott Kilau is handing off the maintainership of the jsm serial
driver to me, and this patch just add the driver as maintained.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f2a2b8e..e2e24b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3331,6 +3331,12 @@ F:	fs/jbd*/
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
1.7.2

