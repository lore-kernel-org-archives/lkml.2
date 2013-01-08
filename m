Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3AHSkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:40:13 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:39386 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab3AHSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:40:08 -0500
From: Lijo Antony <lijo.kernel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@braille.uwo.ca,
        samuel.thibault@ens-lyon.org, linux-kernel@vger.kernel.org,
        Lijo Antony <lijo.kernel@gmail.com>
Subject: [PATCH 3/3] Staging: speakup: kobjects.c: checkpatch.pl fixes
Date: Tue,  8 Jan 2013 22:39:03 +0400
Message-Id: <1357670343-15021-3-git-send-email-lijo.kernel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357670343-15021-1-git-send-email-lijo.kernel@gmail.com>
References: <1357670343-15021-1-git-send-email-lijo.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed two "line over 80 characters" warnings reported by checkpatch.pl

Signed-off-by: Lijo Antony <lijo.kernel@gmail.com>
---
 drivers/staging/speakup/kobjects.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
index 86387f4..35f647c 100644
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -654,16 +654,16 @@ ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
 		if (synth && synth->default_pitch) {
 			param = spk_var_header_by_name("pitch");
 			if (param)  {
-				spk_set_num_var(synth->default_pitch[value], param,
-					E_NEW_DEFAULT);
+				spk_set_num_var(synth->default_pitch[value],
+						param, E_NEW_DEFAULT);
 				spk_set_num_var(0, param, E_DEFAULT);
 			}
 		}
 		if (synth && synth->default_vol) {
 			param = spk_var_header_by_name("vol");
 			if (param)  {
-				spk_set_num_var(synth->default_vol[value], param,
-					E_NEW_DEFAULT);
+				spk_set_num_var(synth->default_vol[value],
+						param, E_NEW_DEFAULT);
 				spk_set_num_var(0, param, E_DEFAULT);
 			}
 		}
-- 
1.7.10.4

