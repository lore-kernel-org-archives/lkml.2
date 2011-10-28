Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1J1Pwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 11:52:41 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:33861 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1J1Pwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 11:52:38 -0400
From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org,
        Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>,
        Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: [PATCH] jsm: Change maintainership
Date: Fri, 28 Oct 2011 13:52:08 -0200
Message-Id: <1319817128-20038-1-git-send-email-lucaskt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 11102815-8936-0000-0000-000004E6811C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breno Leitao has passed the maintainership on to me.

Signed-off-by: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
CC: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 27af9c9..84b0b5e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3654,7 +3654,7 @@ F:	fs/jbd2/
 F:	include/linux/jbd2.h
 
 JSM Neo PCI based serial card
-M:	Breno Leitao <leitao@linux.vnet.ibm.com>
+M:	Lucas Tavares <lucaskt@linux.vnet.ibm.com>
 L:	linux-serial@vger.kernel.org
 S:	Maintained
 F:	drivers/tty/serial/jsm/
-- 
1.7.4.4

