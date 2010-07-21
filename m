Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0GUEwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:52:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40697 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0GUEwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vG3IgT9oC9y4P8XJPJxsNzO0G23LYw39jK4FJVaBgpGy7pE7Ipx7d97bAd2FhUSgcI
         csIVKKhfrSE8SweaWkoRA32lAXUxOfPBitbK47am4qFSH2z22urOo48MkeLNPSBtFr/g
         1DgiCtLG1o42ivgFNeCigQcDkDEJj769sO2jk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 20/20]Documentation/development-process/4.Coding update web address.
Date: Tue, 20 Jul 2010 21:51:56 -0700
Message-Id: <1279687926-29360-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/development-process/4.Coding |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/development-process/4.Coding b/Documentation/development-process/4.Coding
index a5a3450..2278693 100644
--- a/Documentation/development-process/4.Coding
+++ b/Documentation/development-process/4.Coding
@@ -281,7 +281,7 @@ With sparse, the programmer can be warned about confusion between
 user-space and kernel-space addresses, mixture of big-endian and
 small-endian quantities, the passing of integer values where a set of bit
 flags is expected, and so on.  Sparse must be installed separately (it can
-be found at http://www.kernel.org/pub/software/devel/sparse/ if your
+be found at https://sparse.wiki.kernel.org/index.php/Main_Page if your
 distributor does not package it); it can then be run on the code by adding
 "C=1" to your make command.
 
-- 
1.7.1.rc1.21.gf3bd6

