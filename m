Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0DFF7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:59:41 -0400
Received: from smtp.nokia.com ([192.100.122.233]:45482 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab0DFF7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:59:17 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [RESEND PATCH v2 1/6] lis3: Add missing constants for 8bit device
Date: Tue,  6 Apr 2010 08:58:40 +0300
Message-Id: <1270533525-15312-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1270533525-15312-1-git-send-email-samu.p.onkalo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Apr 2010 05:58:54.0222 (UTC) FILETIME=[3D11C2E0:01CAD54E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Definitions for click were missing.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
Tested-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/hwmon/lis3lv02d.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index e6a01f4..692e244 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -196,6 +196,16 @@ enum lis3lv02d_dd_src {
 	DD_SRC_IA	= 0x40,
 };
 
+enum lis3lv02d_click_src_8b {
+	CLICK_SINGLE_X	= 0x01,
+	CLICK_DOUBLE_X	= 0x02,
+	CLICK_SINGLE_Y	= 0x04,
+	CLICK_DOUBLE_Y	= 0x08,
+	CLICK_SINGLE_Z	= 0x10,
+	CLICK_DOUBLE_Z	= 0x20,
+	CLICK_IA	= 0x40,
+};
+
 struct axis_conversion {
 	s8	x;
 	s8	y;
-- 
1.6.0.4

