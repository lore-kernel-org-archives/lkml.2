Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2BPNz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:55:28 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51411 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab2BPNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:55:25 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Christine Caulfield <ccaulfie@redhat.com>
Cc: Danny Kukawka <dkukawka@suse.de>, David Teigland <teigland@redhat.com>,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/dlm/rcom.c: included member.h twice
Date: Thu, 16 Feb 2012 14:55:21 +0100
Message-Id: <1329400521-31738-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329400525;3061359c;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/dlm/rcom.c included 'member.h' twice, remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 fs/dlm/rcom.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index ac5c616..3464d6c 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -23,7 +23,6 @@
 #include "memory.h"
 #include "lock.h"
 #include "util.h"
-#include "member.h"
 
 
 static int rcom_response(struct dlm_ls *ls)
-- 
1.7.8.3

