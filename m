Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab2GANnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:43:37 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:3313 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932456Ab2GANng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:43:36 -0400
Message-ID: <1341150215.1911.117.camel@x61.thuisdomein>
Subject: [PATCH 3/6] [TRIVIAL] pci: remove unused .gitignore file
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 01 Jul 2012 15:43:35 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Jul 2012 13:43:35.0780 (UTC) FILETIME=[8343A240:01CD578F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 982245f01734e9d5a3ab98b2b2e9761ae7719094 ("remove
CONFIG_PCI_NAMES") removed pci's usage of classlist.h, devlist.h, and
gen-devlist. Remove pci's .gitignore file, because now none of its
entries are used.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with git grep only.

 drivers/pci/.gitignore |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)
 delete mode 100644 drivers/pci/.gitignore

diff --git a/drivers/pci/.gitignore b/drivers/pci/.gitignore
deleted file mode 100644
index f297ca8..0000000
--- a/drivers/pci/.gitignore
+++ /dev/null
@@ -1,4 +0,0 @@
-classlist.h
-devlist.h
-gen-devlist
-
-- 
1.7.7.6

