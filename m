Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0IKQfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 12:35:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57387 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab0IKQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 12:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G/J7e9UpSVuy4upsRAbGd8OvBOe9AcvCYyNMFv7yQzzA7U5d5lbC6bSZhgs80aInrc
         7zivUOH2q34yTsz3BOKkMhB33sjDdEgTCIdrrUvkksmlEr+bgo61rvdMOEfBBxmHAL3P
         rzz/wR55KBEQpQqg5vdmY5ACrIKVIZv8TGLLs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 8/8]sound/pci/ac97/ac97_patch.c Update broken web addresses.
Date: Sat, 11 Sep 2010 09:35:28 -0700
Message-Id: <1284222928-4150-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284222928-4150-1-git-send-email-justinmattock@gmail.com>
References: <1284222928-4150-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 sound/pci/ac97/ac97_patch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/ac97/ac97_patch.c b/sound/pci/ac97/ac97_patch.c
index e68c98e..de4641c 100644
--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -3874,7 +3874,7 @@ static int patch_lm4550(struct snd_ac97 *ac97)
 }
 
 /* 
- *  UCB1400 codec (http://www.semiconductors.philips.com/acrobat_download/datasheets/UCB1400-02.pdf)
+ *  UCB1400 codec (http://web.archive.org/web/*/http://www.semiconductors.philips.com/acrobat_download/datasheets/UCB1400-02.pdf)
  */
 static const struct snd_kcontrol_new snd_ac97_controls_ucb1400[] = {
 /* enable/disable headphone driver which allows direct connection to
-- 
1.7.2.1

