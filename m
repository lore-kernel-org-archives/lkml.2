Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab2BKN4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 08:56:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54949 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2BKN4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 08:56:10 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]Typos: change aditional to additional.
Date: Sat, 11 Feb 2012 05:55:58 -0800
Message-Id: <1328968558-18286-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes some typos "aditional" to "additional", and also fixes
a comment with another word mispelled.
 
Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/powerpc/include/asm/keylargo.h |    2 +-
 drivers/hwmon/tmp401.c              |    2 +-
 fs/ntfs/layout.h                    |    4 ++--
 sound/pci/hda/patch_conexant.c      |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/keylargo.h b/arch/powerpc/include/asm/keylargo.h
index fc195d0..2156315 100644
--- a/arch/powerpc/include/asm/keylargo.h
+++ b/arch/powerpc/include/asm/keylargo.h
@@ -21,7 +21,7 @@
 #define KEYLARGO_FCR4		0x48
 #define KEYLARGO_FCR5		0x4c	/* Pangea only */
 
-/* K2 aditional FCRs */
+/* K2 additional FCRs */
 #define K2_FCR6			0x34
 #define K2_FCR7			0x30
 #define K2_FCR8			0x2c
diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index 8b9a774..951442a 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -624,7 +624,7 @@ static int tmp401_probe(struct i2c_client *client,
 			goto exit_remove;
 	}
 
-	/* Register aditional tmp411 sysfs hooks */
+	/* Register additional tmp411 sysfs hooks */
 	if (data->kind == tmp411) {
 		for (i = 0; i < ARRAY_SIZE(tmp411_attr); i++) {
 			err = device_create_file(&client->dev,
diff --git a/fs/ntfs/layout.h b/fs/ntfs/layout.h
index faece71..809c0e6 100644
--- a/fs/ntfs/layout.h
+++ b/fs/ntfs/layout.h
@@ -2008,14 +2008,14 @@ typedef struct {
  *
  * When a directory is small enough to fit inside the index root then this
  * is the only attribute describing the directory. When the directory is too
- * large to fit in the index root, on the other hand, two aditional attributes
+ * large to fit in the index root, on the other hand, two additional attributes
  * are present: an index allocation attribute, containing sub-nodes of the B+
  * directory tree (see below), and a bitmap attribute, describing which virtual
  * cluster numbers (vcns) in the index allocation attribute are in use by an
  * index block.
  *
  * NOTE: The root directory (FILE_root) contains an entry for itself. Other
- * dircetories do not contain entries for themselves, though.
+ * directories do not contain entries for themselves, though.
  */
 typedef struct {
 	ATTR_TYPE type;			/* Type of the indexed attribute. Is
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index a7a5733..51e3ed4 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1643,7 +1643,7 @@ static void cxt5051_update_speaker(struct hda_codec *codec)
 	pinctl = (!spec->hp_present && spec->cur_eapd) ? PIN_OUT : 0;
 	snd_hda_codec_write(codec, 0x1a, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
 			    pinctl);
-	/* on ideapad there is an aditional speaker (subwoofer) to mute */
+	/* on ideapad there is an additional speaker (subwoofer) to mute */
 	if (spec->ideapad)
 		snd_hda_codec_write(codec, 0x1b, 0,
 				    AC_VERB_SET_PIN_WIDGET_CONTROL,
-- 
1.7.9

