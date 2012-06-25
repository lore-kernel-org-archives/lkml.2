Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2FYEuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 00:50:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59252 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2FYEuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 00:50:22 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
Date: Mon, 25 Jun 2012 13:50:21 +0900
X-Google-Sender-Auth: 2_C553sHIVxh8hyssMRIlYaYC1o
Message-ID: <CAJ0PZbTLEtUb0D9xvr6WQu-L6FXU6=zhx5FSKpttgtNPkXsUdw@mail.gmail.com>
Subject: [PATCH] MAINTAINERS: Add entries for extcon (external connector) subsystem.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>, Mike Lockwood <lockwood@android.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e30a3a..c27ecab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2704,6 +2704,14 @@ S:	Maintained
 F:	Documentation/filesystems/ext4.txt
 F:	fs/ext4/

+EXTERNAL CONNECTOR SUBSYSTEM (EXTCON)
+M:	MyungJoo Ham <myungjoo.ham@samsung.com>
+M:	Chanwoo Choi <cw00.choi@samsung.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/extcon/
+F:	Documentation/extcon/
+
 Extended Verification Module (EVM)
 M:	Mimi Zohar <zohar@us.ibm.com>
 S:	Supported
-- 
1.7.4.1
