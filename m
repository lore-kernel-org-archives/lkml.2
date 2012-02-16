Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab2BPNzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:55:36 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51417 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab2BPNzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:55:33 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: Danny Kukawka <dkukawka@suse.de>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs/check-integrity.c: included disk-io.h twice
Date: Thu, 16 Feb 2012 14:55:29 +0100
Message-Id: <1329400529-31793-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329400533;09d13c0f;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/btrfs/check-integrity.c included disk-io.h twice, remove the
duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 fs/btrfs/check-integrity.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index b669a7d..064b29b 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -89,7 +89,6 @@
 #include "disk-io.h"
 #include "transaction.h"
 #include "extent_io.h"
-#include "disk-io.h"
 #include "volumes.h"
 #include "print-tree.h"
 #include "locking.h"
-- 
1.7.8.3

