Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1HEKqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:46:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52239 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab1HEKqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:46:20 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: tiwai@suse.de, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] ALSA: hda - Fix a complile warning in patch_via.c
Date: Fri,  5 Aug 2011 18:51:29 +0800
Message-Id: <1312541489-8494-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  sound/pci/hda/patch_via.c:2087: warning: 'dac' may be used uninitialized in this function

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 sound/pci/hda/patch_via.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 84d8798..4ebfbd8 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -2084,7 +2084,7 @@ static int via_auto_create_speaker_ctls(struct hda_codec *codec)
 	struct via_spec *spec = codec->spec;
 	struct nid_path *path;
 	bool check_dac;
-	hda_nid_t pin, dac;
+	hda_nid_t pin, dac = 0;
 	int err;
 
 	pin = spec->autocfg.speaker_pins[0];
-- 
1.7.4.1

