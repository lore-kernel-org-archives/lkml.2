Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1BQC7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:59:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46541 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1BQC7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:59:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=j1WKu+dHWbqsKFCnjMZ6KN05GHBUmdDpO53ef/e7a0ZE/R5nyUFTtZnvuieeh/g/HM
         Q3CqarPd0ab/WJBbWYJqqUEw7CEqw5Dd9H4TsyczpxyOGegLxrkLaSAen3u8CVTOUpkK
         /GHB50WSbXkJhsMrtYMCtz6wF1/mc55vpWqeI=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>
Subject: [PATCH 08/10] Staging: tidspbridge: fixed missing space after struct definition
Date: Thu, 17 Feb 2011 03:58:52 +0100
Message-Id: <1297911534-31534-8-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297911534-31534-7-git-send-email-klaas.neirinck@gmail.com>
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-2-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-3-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-4-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-5-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-6-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-7-git-send-email-klaas.neirinck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue.

Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>

diff --git a/drivers/staging/tidspbridge/include/dspbridge/sync.h b/drivers/staging/tidspbridge/include/dspbridge/sync.h
index e2651e7..4d0835c 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/sync.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/sync.h
@@ -31,7 +31,7 @@
  * @multi_comp:	use to signal multiple events.
  *
  */
-struct sync_object{
+struct sync_object {
 	struct completion comp;
 	struct completion *multi_comp;
 };
-- 
1.7.1

