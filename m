Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab1DNOPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:15:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42560 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200Ab1DNOPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Yh9KcU8PfMttfhcP/Fj8VnWkT/TIFid2SIVrVMH+T0d4PNzNa1DIbZTAqiZ44L3S1Y
         //0v+NwmbL7nmnr/m3WxdsMl6hu7N+mS7k5mpQOPP3dYrj+mGoDO7TFcPCN0hOSi6QTi
         zJ4/uN7xFmgKR5F+j1JTJTbJ6ul/ot8FRxNfA=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: [PATCH] Documentation: epoll: remove entry about max_user_instances
Date: Thu, 14 Apr 2011 16:15:00 +0200
Message-Id: <1302790500-16951-1-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_user_instances was removed in this commit:

   commit 9df04e1f25effde823a600e755b51475d438f56b
   Author: Davide Libenzi <davidel@xmailserver.org>
   Date:   Thu Jan 29 14:25:26 2009 -0800

    epoll: drop max_user_instances and rely only on max_user_watches

but the documentation entry was not removed.

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 Documentation/sysctl/fs.txt |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index 4af0614..88fd7f5 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -231,13 +231,6 @@ its creation).
 
 This directory contains configuration options for the epoll(7) interface.
 
-max_user_instances
-------------------
-
-This is the maximum number of epoll file descriptors that a single user can
-have open at a given time. The default value is 128, and should be enough
-for normal users.
-
 max_user_watches
 ----------------
 
-- 
1.7.5.rc0

