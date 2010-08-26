Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0HZFGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 01:06:05 -0400
Received: from fox.seas.upenn.edu ([158.130.68.12]:54144 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0HZFFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 01:05:36 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Aug 2010 01:05:35 EDT
From: Rafi Rubin <rafi@seas.upenn.edu>
To: jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com, chatty@enac.fr,
        micki@n-trig.com, Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 2/4] a bit of whitespace cleanup
Date: Thu, 26 Aug 2010 00:54:55 -0400
Message-Id: <1282798497-19791-3-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282798497-19791-1-git-send-email-rafi@seas.upenn.edu>
References: <1282798497-19791-1-git-send-email-rafi@seas.upenn.edu>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-08-26_03:2010-08-26,2010-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1008250268
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
---
 drivers/hid/hid-ntrig.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index fb69b8c..43e95de 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -377,8 +377,8 @@ static struct attribute_group ntrig_attribute_group = {
  */
 
 static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+			       struct hid_field *field, struct hid_usage *usage,
+			       unsigned long **bit, int *max)
 {
 	struct ntrig_data *nd = hid_get_drvdata(hdev);
 
@@ -448,13 +448,13 @@ static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		/* width/height mapped on TouchMajor/TouchMinor/Orientation */
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_TOUCH_MAJOR);
+				      EV_ABS, ABS_MT_TOUCH_MAJOR);
 			return 1;
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
-					EV_ABS, ABS_MT_TOUCH_MINOR);
+				      EV_ABS, ABS_MT_TOUCH_MINOR);
 			input_set_abs_params(hi->input, ABS_MT_ORIENTATION,
-					0, 1, 0, 0);
+					     0, 1, 0, 0);
 			return 1;
 		}
 		return 0;
@@ -468,8 +468,8 @@ static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 }
 
 static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+			      struct hid_field *field, struct hid_usage *usage,
+			      unsigned long **bit, int *max)
 {
 	/* No special mappings needed for the pen and single touch */
 	if (field->physical)
@@ -489,7 +489,7 @@ static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
  * and call input_mt_sync after each point if necessary
  */
 static int ntrig_event (struct hid_device *hid, struct hid_field *field,
-		                        struct hid_usage *usage, __s32 value)
+			struct hid_usage *usage, __s32 value)
 {
 	struct input_dev *input = field->hidinput->input;
 	struct ntrig_data *nd = hid_get_drvdata(hid);
@@ -860,7 +860,7 @@ err_free:
 static void ntrig_remove(struct hid_device *hdev)
 {
 	sysfs_remove_group(&hdev->dev.kobj,
-			&ntrig_attribute_group);
+			   &ntrig_attribute_group);
 	hid_hw_stop(hdev);
 	kfree(hid_get_drvdata(hdev));
 }
-- 
1.7.1

