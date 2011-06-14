Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1FNRKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:10:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38364 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1FNRKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:10:52 -0400
Subject: [PATCH] dt: include linux/errno.h in linux/of_address.h
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 14 Jun 2011 11:10:50 -0600
Message-ID: <20110614171046.15445.77945.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_address.h makes reference to some of the error code #defines, so it
needs to include errno.h.  If CONFIG_PCI is not selected, then some files
will fail to compile.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 include/linux/of_address.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 4fbea28..b651028 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -1,6 +1,7 @@
 #ifndef __OF_ADDRESS_H
 #define __OF_ADDRESS_H
 #include <linux/ioport.h>
+#include <linux/errno.h>
 #include <linux/of.h>
 
 extern int of_address_count(struct device_node *np);

