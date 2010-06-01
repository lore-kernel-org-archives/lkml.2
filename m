Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0FAXcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 19:32:14 -0400
Received: from relay10.uol.com.br ([200.147.1.0]:37245 "EHLO
	relay10.uol.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab0FAXcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 19:32:12 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
X-UOL-SMTP: SMTPS25
From: =?UTF-8?q?Rog=C3=A9rio=20Brito?= <rbrito@ime.usp.br>
Cc: =?UTF-8?q?Rog=C3=A9rio=20Brito?= <rbrito@ime.usp.br>,
       linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 3/3] scripts: Change section of generated debian packages to kernel
Date: Tue,  1 Jun 2010 20:22:04 -0300
Message-Id: <1275434524-2025-3-git-send-email-rbrito@ime.usp.br>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275434524-2025-1-git-send-email-rbrito@ime.usp.br>
References: <1275434524-2025-1-git-send-email-rbrito@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-kbuild@vger.kernel.org
X-SIG5: 5f9cf9a6f41a222ef51a59741a19d130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow the way that Official Debian kernel packages are made, put the
generated packages in the right section, the kernel section.  This also
avoids polluting the admin section.

Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
---
 scripts/package/builddeb |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 784f67d..5f1e2fc 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -148,7 +148,7 @@ EOF
 # Generate a control file
 cat <<EOF > debian/control
 Source: linux-upstream
-Section: admin
+Section: kernel
 Priority: optional
 Maintainer: $maintainer
 Standards-Version: 3.8.4
-- 
1.7.1

