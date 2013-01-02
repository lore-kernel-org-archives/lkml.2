Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3ABGI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 01:08:28 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46112 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3ABGI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 01:08:26 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Fix typo of URL pointing to Media Controller API's
Date: Wed,  2 Jan 2013 11:38:15 +0530
Message-Id: <1357106895-4360-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/video4linux/fimc.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/fimc.txt b/Documentation/video4linux/fimc.txt
index fd02d9a..25f4d34 100644
--- a/Documentation/video4linux/fimc.txt
+++ b/Documentation/video4linux/fimc.txt
@@ -58,7 +58,7 @@ Not currently supported:
 4.1. Media device interface
 
 The driver supports Media Controller API as defined at
-http://http://linuxtv.org/downloads/v4l-dvb-apis/media_common.html
+http://linuxtv.org/downloads/v4l-dvb-apis/media_common.html
 The media device driver name is "SAMSUNG S5P FIMC".
 
 The purpose of this interface is to allow changing assignment of FIMC instances
-- 
1.7.4.1

