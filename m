Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762414Ab0GUFGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:06:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762277Ab0GUE6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bnuOQ/cwK7keAImDMNWpZ+CJl+HQEo/KDgcsQLmvZTUgtw7WVnR3M7aEGD6PW6vmyA
         m/QIptQIwojulRgVbwwCREuYVQFzBVLJw/75NdoTFRFZ3aUFoAKk7p2tnkwtT622hl7m
         yB5bxwwabE7tlWfeK1N50q/2rxQfhStV2mJLQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 111/111]Documentation/sound/alsa/soc/codec.txt update web address.
Date: Tue, 20 Jul 2010 21:57:50 -0700
Message-Id: <1279688279-29683-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/sound/alsa/soc/codec.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/sound/alsa/soc/codec.txt b/Documentation/sound/alsa/soc/codec.txt
index 1e95342..37ba3a7 100644
--- a/Documentation/sound/alsa/soc/codec.txt
+++ b/Documentation/sound/alsa/soc/codec.txt
@@ -143,7 +143,7 @@ struct snd_soc_ops {
 };
 
 Please refer to the ALSA driver PCM documentation for details.
-http://www.alsa-project.org/~iwai/writing-an-alsa-driver/c436.htm
+http://www.alsa-project.org/~iwai/writing-an-alsa-driver/
 
 
 5 - DAPM description.
-- 
1.7.1.rc1.21.gf3bd6

