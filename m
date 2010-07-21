Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab0GUE7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:59:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39306 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762287Ab0GUE6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pdZMnkRkFM0oDHuyf1MK3UDUpI8iydfofUcOr+aV/ei5xz8+VP4OXGlRonXw7BaLS8
         bDNV6lqc5au42kHn5Z9RtEuAyMfZe68MMMiJ4HL6rqOZ9f0VqHrZ1YUZexOuHGZIf+7k
         P4cnypgoo0qExwx8ChaWuj3635nqlSwnlcTjc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 113/113]Documentation/sound/alsa/soc/platform.txt update web address.
Date: Tue, 20 Jul 2010 21:57:52 -0700
Message-Id: <1279688279-29683-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/sound/alsa/soc/platform.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/sound/alsa/soc/platform.txt b/Documentation/sound/alsa/soc/platform.txt
index b681d17..06d8359 100644
--- a/Documentation/sound/alsa/soc/platform.txt
+++ b/Documentation/sound/alsa/soc/platform.txt
@@ -39,7 +39,7 @@ struct snd_soc_platform {
 };
 
 Please refer to the ALSA driver documentation for details of audio DMA.
-http://www.alsa-project.org/~iwai/writing-an-alsa-driver/c436.htm
+http://www.alsa-project.org/~iwai/writing-an-alsa-driver/
 
 An example DMA driver is soc/pxa/pxa2xx-pcm.c
 
-- 
1.7.1.rc1.21.gf3bd6

