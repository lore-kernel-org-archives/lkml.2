Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2LTGdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:33:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:62566 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2LTGdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:33:13 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-fc-50d2b11c66cc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/6] backlight: s6e63m0: use lowercase names of structs
Date: Thu, 20 Dec 2012 15:33:00 +0900
Message-id: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3ee9s5WLGjeuuhRceS0Ez4r5xE9A==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zA12ZjZcCDHYeM7S4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZM47cYClYJ1tx8fFetgbGFeJdjJwcEgImEq+utbBB2GISF+6t
	B7K5OIQEljFKLNyxmh2m6NyMCVCJ6YwSf+7eZYZwZjNJvD/1FKyKTUBN4suXw2C2iECERPOM
	WUBFHBzMAj4Sm2dpgoSFBdwlVq58BraNRUBVYsfZuUwgNq+ArcSx260sELagxI/J98BsZgEt
	ifU7jzNB2PISm9e8BRspIaAu8eivLsQmPYnbz/YyQpSISOx78Y4RYryAxLfJh1ggymUlNh1g
	hnilmV2i/5Y8hC0pcXDFDZYJjGKzkCyehWTxLCSLZyHZsICRZRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGSJxI7WBc2WBxiFGAg1GJh3fRtEsBQqyJZcWVuYcYJTiYlUR4F966GCDEm5JY
	WZValB9fVJqTWnyI0Qfo8InMUqLJ+cAYziuJNzQ2NjEzMTUxtzQ1N8UhrCTO2+yREiAkkJ5Y
	kpqdmlqQWgQzjomDU6qBsSv5cMN3Xj+9ubFRBakzd27R36iwQXDr0R8hf1RmJNyOccyvOjsl
	S/S7rfqSGY9ecG760LxkuoSn7hkDow2xuTveGUvs/j9xy7Ok+14OKTtWqZWZX+x5597VdaKm
	7rzToWSDWTWSYoJGn2ui2M0NAlRe3E7T0Wael/L07UxOIYsnhoWeEr8eKbEUZyQaajEXFScC
	AEYAINnAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQV2ZjZcCDPYc0bW4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGTOO3GApWCdbcfHxXrYG
	xhXiXYycHBICJhLnZkxgg7DFJC7cWw9kc3EICUxnlPhz9y4zhDObSeL9qafsIFVsAmoSX74c
	BrNFBCIkmmfMAiri4GAW8JHYPEsTJCws4C6xcuUzsKEsAqoSO87OZQKxeQVsJY7dbmWBsAUl
	fky+B2YzC2hJrN95nAnClpfYvOYt2EgJAXWJR391ITbpSdx+tpcRokREYt+Ld4wTGAVmIZk0
	C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcBw+k9rBuLLB4hCjAAej
	Eg/vommXAoRYE8uKK3MPMUpwMCuJ8C68dTFAiDclsbIqtSg/vqg0J7X4EKMP0KMTmaVEk/OB
	KSKvJN7Q2MTMyNLIzMLIxNwch7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsYjS5IOnNqe
	0Hkn4RbTdFXmDQZV96XyXlkJzty1ZuWiv8pf3xROd5jx8UWvskjE64rY+AXtqhoZnPP3G1aY
	fZ49gdOTST/fKrRbgHWFl0NQYJDXV27hv8dK8h42MnfNX2ajnyzPYrDKOvVA2kVGY3l2Ft9v
	rG0FN+o+MNqu5r/6tDBFcmPPDyWW4oxEQy3mouJEAFLSmg/wAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lowercase names of structs should be used, because they are
not preprocessor macros.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/s6e63m0.c |   40 ++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 3e1c113..cae140d 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -57,7 +57,7 @@ struct s6e63m0 {
 	struct lcd_platform_data	*lcd_pd;
 };
 
-static const unsigned short SEQ_PANEL_CONDITION_SET[] = {
+static const unsigned short seq_panel_condition_set[] = {
 	0xF8, 0x01,
 	DATA_ONLY, 0x27,
 	DATA_ONLY, 0x27,
@@ -76,7 +76,7 @@ static const unsigned short SEQ_PANEL_CONDITION_SET[] = {
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_DISPLAY_CONDITION_SET[] = {
+static const unsigned short seq_display_condition_set[] = {
 	0xf2, 0x02,
 	DATA_ONLY, 0x03,
 	DATA_ONLY, 0x1c,
@@ -90,7 +90,7 @@ static const unsigned short SEQ_DISPLAY_CONDITION_SET[] = {
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_GAMMA_SETTING[] = {
+static const unsigned short seq_gamma_setting[] = {
 	0xfa, 0x00,
 	DATA_ONLY, 0x18,
 	DATA_ONLY, 0x08,
@@ -119,7 +119,7 @@ static const unsigned short SEQ_GAMMA_SETTING[] = {
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_ETC_CONDITION_SET[] = {
+static const unsigned short seq_etc_condition_set[] = {
 	0xf6, 0x00,
 	DATA_ONLY, 0x8c,
 	DATA_ONLY, 0x07,
@@ -318,47 +318,47 @@ static const unsigned short SEQ_ETC_CONDITION_SET[] = {
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_ACL_ON[] = {
+static const unsigned short seq_acl_on[] = {
 	/* ACL on */
 	0xc0, 0x01,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_ACL_OFF[] = {
+static const unsigned short seq_acl_off[] = {
 	/* ACL off */
 	0xc0, 0x00,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_ELVSS_ON[] = {
+static const unsigned short seq_elvss_on[] = {
 	/* ELVSS on */
 	0xb1, 0x0b,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_ELVSS_OFF[] = {
+static const unsigned short seq_elvss_off[] = {
 	/* ELVSS off */
 	0xb1, 0x0a,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_STAND_BY_OFF[] = {
+static const unsigned short seq_stand_by_off[] = {
 	0x11, COMMAND_ONLY,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_STAND_BY_ON[] = {
+static const unsigned short seq_stand_by_on[] = {
 	0x10, COMMAND_ONLY,
 
 	ENDDEF, 0x0000
 };
 
-static const unsigned short SEQ_DISPLAY_ON[] = {
+static const unsigned short seq_display_on[] = {
 	0x29, COMMAND_ONLY,
 
 	ENDDEF, 0x0000
@@ -457,12 +457,12 @@ static int s6e63m0_ldi_init(struct s6e63m0 *lcd)
 {
 	int ret, i;
 	const unsigned short *init_seq[] = {
-		SEQ_PANEL_CONDITION_SET,
-		SEQ_DISPLAY_CONDITION_SET,
-		SEQ_GAMMA_SETTING,
-		SEQ_ETC_CONDITION_SET,
-		SEQ_ACL_ON,
-		SEQ_ELVSS_ON,
+		seq_panel_condition_set,
+		seq_display_condition_set,
+		seq_gamma_setting,
+		seq_etc_condition_set,
+		seq_acl_on,
+		seq_elvss_on,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
@@ -478,8 +478,8 @@ static int s6e63m0_ldi_enable(struct s6e63m0 *lcd)
 {
 	int ret = 0, i;
 	const unsigned short *enable_seq[] = {
-		SEQ_STAND_BY_OFF,
-		SEQ_DISPLAY_ON,
+		seq_stand_by_off,
+		seq_display_on,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(enable_seq); i++) {
@@ -495,7 +495,7 @@ static int s6e63m0_ldi_disable(struct s6e63m0 *lcd)
 {
 	int ret;
 
-	ret = s6e63m0_panel_send_sequence(lcd, SEQ_STAND_BY_ON);
+	ret = s6e63m0_panel_send_sequence(lcd, seq_stand_by_on);
 
 	return ret;
 }
-- 
1.7.2.5


