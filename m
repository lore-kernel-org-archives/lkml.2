Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1C1Qdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:33:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48024 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab1C1Qa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WYU+hAxdDDOKIHxBRQ/8EzA2gHy26dor6RTSUlUg+2eyZ/8rootpXasOM1V0kOk80e
         eUWofTQubPuXNo/Ud2GOAIdQsGhPAHCAAONA9HMuByy9ughJHjCAAEJk0pdQJQfXV6ZK
         pxwLKOFzbhsNhrD8rCoTVerFqOgk8fe5OrlRQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 13/25]drivers:uwb:uwb-internal.h Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:36 -0700
Message-Id: <1301329788-3423-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/uwb/uwb-internal.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/uwb/uwb-internal.h b/drivers/uwb/uwb-internal.h
index 157485c..a7494bf 100644
--- a/drivers/uwb/uwb-internal.h
+++ b/drivers/uwb/uwb-internal.h
@@ -28,7 +28,6 @@
 #ifndef __UWB_INTERNAL_H__
 #define __UWB_INTERNAL_H__
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/uwb.h>
-- 
1.7.4.1

