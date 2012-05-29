Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2E2W1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 18:27:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2E2W1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 18:27:44 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Rodolfo Giometti <giometti@enneenne.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] Documentation/pps: Fix a small spell mistake
Date: Wed, 30 May 2012 03:57:35 +0530
Message-Id: <1338330455-6805-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 Documentation/pps/pps.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/pps/pps.txt b/Documentation/pps/pps.txt
index d35dcdd..c3228fd 100644
--- a/Documentation/pps/pps.txt
+++ b/Documentation/pps/pps.txt
@@ -34,7 +34,7 @@ and record it for userland.
 
 Common use is the combination of the NTPD as userland program, with a
 GPS receiver as PPS source, to obtain a wallclock-time with
-sub-millisecond synchronisation to UTC.
+sub-millisecond synchronization to UTC.
 
 
 RFC considerations
-- 
1.7.9.5

