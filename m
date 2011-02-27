Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab1B0EfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:35:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40844 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1B0Ee6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kEWEz47M05WShfGbSolv08LTAeOtqLk7g7IuWiCqJUXfRXogkwQkBhtF72pLMtstGx
         e/QDk12QxxP225KWcZKL3XWLqiu/cdvwHCn+n0aOTj5xXF5VTUYkjmur5uzbl6yzBleZ
         7jQwnE8srZGpSfIRZZklOuwEDphK2n5iyivT8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 17/17]sound:core:seq:seq_ports.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:10 -0800
Message-Id: <1298781250-2718-18-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org
---
 sound/core/seq/seq_ports.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/core/seq/seq_ports.c b/sound/core/seq/seq_ports.c
index 3bf7d73..e12bcd9 100644
--- a/sound/core/seq/seq_ports.c
+++ b/sound/core/seq/seq_ports.c
@@ -412,7 +412,7 @@ int snd_seq_get_port_info(struct snd_seq_client_port * port,
  * initialization or termination of devices (see seq_midi.c).
  *
  * If callback_all option is set, the callback function is invoked
- * at each connnection/disconnection. 
+ * at each connection/disconnection. 
  */
 
 static int subscribe_port(struct snd_seq_client *client,
-- 
1.7.4.1

