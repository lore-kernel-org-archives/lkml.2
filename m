Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250Ab0GUE5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:57:52 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381Ab0GUE4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pWrKs26gKKsxdcacKXIBtscUETvEsa1iZMhod+LBcqVZRYe1xV6SdLKhddrtaqFdQj
         SXGh61K6mlv2OJWU7CxTTNX3nOf6HNuod45UCXXH/LGQof8xDzw7W6WVaYc9D6ewfmQP
         vFTmBItm+QKgDO03RP/FeWfLTB4X2syNnv3us=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 92/92]Documentation/powerpc/booting-without-of.txt update web address.
Date: Tue, 20 Jul 2010 21:56:42 -0700
Message-Id: <1279688215-29628-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/powerpc/booting-without-of.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
index 46d2210..7882a10 100644
--- a/Documentation/powerpc/booting-without-of.txt
+++ b/Documentation/powerpc/booting-without-of.txt
@@ -1048,7 +1048,7 @@ IV - "dtc", the device tree compiler
 
 
 dtc source code can be found at
-<http://ozlabs.org/~dgibson/dtc/dtc.tar.gz>
+<http://ozlabs.org/>
 
 WARNING: This version is still in early development stage; the
 resulting device-tree "blobs" have not yet been validated with the
-- 
1.7.1.rc1.21.gf3bd6

