Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0HJGlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 02:41:12 -0400
Received: from www84.your-server.de ([213.133.104.84]:57008 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab0HJGlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 02:41:10 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andi@firstfloor.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
        tytso@mit.edu, iws@ovro.caltech.edu
Cc: stefani@seibold.net
Subject: [PATCH 3/4] replace the old non generic API
Date: Tue, 10 Aug 2010 08:40:39 +0200
Message-Id: <1281422440-23455-4-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1281422440-23455-1-git-send-email-stefani@seibold.net>
References: <1281422440-23455-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch simple replace the whole kfifo.c and kfifo.h files by the new
generic version and fix the kerneldoc API template file.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 Documentation/DocBook/kernel-api.tmpl |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index 44b3def..a20c6f6 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -132,7 +132,6 @@ X!Ilib/string.c
      <title>FIFO Buffer</title>
      <sect1><title>kfifo interface</title>
 !Iinclude/linux/kfifo.h
-!Ekernel/kfifo.c
      </sect1>
   </chapter>
 
-- 
1.7.2

