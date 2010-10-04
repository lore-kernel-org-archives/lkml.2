Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab0JDUoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:44:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49067 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab0JDUow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=foWkIM6NOsmvdDcjAaztWeHjPmht/7nIUSLne4/r2zDMb2T1G+UQNiRZiY9z9uyfpV
         Bl3M/FrbvZErw6fpVJi04XyKZzPIp8wKhAH/sXYm6zZgPbMGq0adCi4BJA59Lz78Y8qa
         fXzRViZbVXPYI6YlFuSp+S9fulj6C8ZvNZbn8=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/5] Coccinelle: Add a link to the wiki
Date: Mon,  4 Oct 2010 22:43:48 +0200
Message-Id: <1286225028-21927-1-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a link to the wiki

Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 Documentation/coccinelle.txt |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index cd2b028..98b8a7f 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -24,6 +24,9 @@ of many distributions, e.g. :
 You can get the latest version released from the Coccinelle homepage at
 http://coccinelle.lip6.fr/
 
+Information and tips about Coccinelle are also provided on the wiki
+pages at http://cocci.ekstranet.diku.dk/wiki/doku.php
+
 Once you have it, run the following command:
 
      	./configure
-- 
1.7.0.4

