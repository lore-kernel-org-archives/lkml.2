Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762518Ab0GUFMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:12:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62879 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762060Ab0GUEzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dVZiyWCowcd4dC434IteyDW3cBZWWs8cnsCBj2TyFdhEKp/LAg544P0vB6xifCEy7R
         /90Z6zUOxN16czuI5ayKhKbKrjl7BUUH5hLUiFhQW4bH3Rbk7q09/3LRrWVfkG+UEwAs
         E6RR/zDUyIULJKIgyktKcMKYxo6CilPososbc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 77/77]Documentation/networking/tlan.txt update web address.
Date: Tue, 20 Jul 2010 21:55:40 -0700
Message-Id: <1279688153-29571-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
References: <1279688153-29571-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address to the best 
that I can.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/networking/tlan.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/tlan.txt b/Documentation/networking/tlan.txt
index 7e6aa5b..34550df 100644
--- a/Documentation/networking/tlan.txt
+++ b/Documentation/networking/tlan.txt
@@ -2,7 +2,7 @@
 (C) 1998 James Banks
 (C) 1999-2001 Torben Mathiasen <tmm@image.dk, torben.mathiasen@compaq.com>
 
-For driver information/updates visit http://opensource.compaq.com
+For driver information/updates visit http://www.compaq.com
 
 
 TLAN driver for Linux, version 1.14a
@@ -113,5 +113,5 @@ III.  Things to try if you have problems.
 
 There is also a tlan mailing list which you can join by sending "subscribe tlan"
 in the body of an email to majordomo@vuser.vu.union.edu.
-There is also a tlan website at http://opensource.compaq.com
+There is also a tlan website at http://www.compaq.com
 
-- 
1.7.1.rc1.21.gf3bd6

