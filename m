Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0FAXYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 19:24:18 -0400
Received: from relay13.uol.com.br ([200.147.32.249]:43588 "EHLO
	relay13.uol.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab0FAXYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 19:24:17 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
X-UOL-SMTP: SMTPS25
From: =?UTF-8?q?Rog=C3=A9rio=20Brito?= <rbrito@ime.usp.br>
Cc: =?UTF-8?q?Rog=C3=A9rio=20Brito?= <rbrito@ime.usp.br>,
       linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 1/3] scripts: Add homepage field to debian/control file
Date: Tue,  1 Jun 2010 20:22:02 -0300
Message-Id: <1275434524-2025-1-git-send-email-rbrito@ime.usp.br>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-kbuild@vger.kernel.org
X-SIG5: 4c1a0d497eadf09ab5b5dc9fc0e2b9d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps when the user sees information of the packages on package
managers like aptitude.

Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
---
 scripts/package/builddeb |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 07f2fbd..d8477a6 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -152,6 +152,7 @@ Section: admin
 Priority: optional
 Maintainer: $maintainer
 Standards-Version: 3.8.1
+Homepage: http://www.kernel.org/
 EOF
 
 if [ "$ARCH" = "um" ]; then
-- 
1.7.1

