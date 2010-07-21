Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170Ab0GUEy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:54:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42452 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762110Ab0GUEyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WnonqFSyUmgWs7x/cj9OpNTQT7vr7vkcO68TzULX3u2U6CsLBsQPmhE1Py2EVYXSMJ
         LWxCn8060wg7w53S9urE9tahQu21oPFu3hU1mFVD2ZpbmZK7MGOpViBu9vhABuncF3bb
         NmTYb4B+D8Exu6zYaYUoBrOea2WUDxuhCpVhY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 54/54]Documentation/infiniband/user_verbs.txt update web address.
Date: Tue, 20 Jul 2010 21:53:53 -0700
Message-Id: <1279688039-29465-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
References: <1279688039-29465-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/infiniband/user_verbs.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/infiniband/user_verbs.txt b/Documentation/infiniband/user_verbs.txt
index afe3f8d..e5092d6 100644
--- a/Documentation/infiniband/user_verbs.txt
+++ b/Documentation/infiniband/user_verbs.txt
@@ -5,7 +5,7 @@ USERSPACE VERBS ACCESS
   described in chapter 11 of the InfiniBand Architecture Specification.
 
   To use the verbs, the libibverbs library, available from
-  <http://openib.org/>, is required.  libibverbs contains a
+  http://www.openfabrics.org/, is required.  libibverbs contains a
   device-independent API for using the ib_uverbs interface.
   libibverbs also requires appropriate device-dependent kernel and
   userspace driver for your InfiniBand hardware.  For example, to use
-- 
1.7.1.rc1.21.gf3bd6

