Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0G0JDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 05:03:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60135 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab0G0JD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 05:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=FV93Acc/09v6s4qb0je5mNEm+A1HbulKg0+6LqTKX46D3WV7XAstU3U2zMkp4nZ2g2
         +J6WHFQGrLmnAcTiYkRWrciw8CgRRUqueAO1/L2Dg9cVRKubI0PlXdC0mtHNAcOBEoMG
         TvnWJdH/rKtODv5O6TQxY9hPrf7SfaMcENceI=
From: =?UTF-8?q?Charles=20Cl=C3=A9ment?= <caratorn@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: linux-doc@vger.kernel.org, rdunlap@xenotime.net, rydberg@euromail.se,
        =?UTF-8?q?Charles=20Cl=C3=A9ment?= <caratorn@gmail.com>
Subject: [PATCH] Fix bcm5974 documentation link
Date: Tue, 27 Jul 2010 11:03:17 +0200
Message-Id: <1280221397-2416-1-git-send-email-caratorn@gmail.com>
X-Mailer: git-send-email 1.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Charles Clément <caratorn@gmail.com>
---
 Documentation/input/bcm5974.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/input/bcm5974.txt b/Documentation/input/bcm5974.txt
index 5e22dcf..74d3876 100644
--- a/Documentation/input/bcm5974.txt
+++ b/Documentation/input/bcm5974.txt
@@ -62,4 +62,4 @@ Links
 -----
 
 [1] http://ubuntuforums.org/showthread.php?t=840040
-[2] http://http://bitmath.org/code/
+[2] http://bitmath.org/code/
-- 
1.7.2

