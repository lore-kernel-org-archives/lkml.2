Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762431Ab0GUFHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:07:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762273Ab0GUE57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HyFnkTTzMQm9qYltiI3GvmANouGXlN5vmIoN1YgRLEeGJZNRrjwRk/FVwTXBhsTECC
         CbPIdQHQkisRH5QyVknfVPEB7I7HVIp8IO97E44qPTjIjSAFnpOa8N1BegusXMWaSSP7
         XeVe+jhOG1E87Vry5ED0UD0TWxtMAIwGBH5XA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 109/109]Documentation/sound/alsa/HD-Audio.txt update web address.
Date: Tue, 20 Jul 2010 21:57:48 -0700
Message-Id: <1279688279-29683-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/sound/alsa/HD-Audio.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/sound/alsa/HD-Audio.txt b/Documentation/sound/alsa/HD-Audio.txt
index bdafdbd..278cc21 100644
--- a/Documentation/sound/alsa/HD-Audio.txt
+++ b/Documentation/sound/alsa/HD-Audio.txt
@@ -562,7 +562,7 @@ compare the codec registers directly.
 Send a bug report either the followings:
 
 kernel-bugzilla::
-  http://bugme.linux-foundation.org/
+  https://bugzilla.kernel.org/
 alsa-devel ML::
   alsa-devel@alsa-project.org
 
-- 
1.7.1.rc1.21.gf3bd6

