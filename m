Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1AYLJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:09:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50775 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1AYLH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:07:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UBKlnHjbviokTYBNHtcjtcHORfPhszDzojPvgIq4cjFztTTufzyrBBZX1O0k35/NxN
         cubxcFnzHbIc9uNN/i3OaldwGqRidebCCIhiLktNyWmTmyUvAN3A9C4kV3f/HCIvjusd
         xZoc5qknwZ+kML3+hznqlUG6qrZhIhPk6cIyM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 06/12] staging: ft1000: Fix coding style.
Date: Tue, 25 Jan 2011 12:08:11 +0100
Message-Id: <1295953697-9805-6-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix conding style in put_handshake_usb() funntion. Probably will be
removed just keep backward compatibility.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index c3f86be..a1d5592 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -321,7 +321,7 @@ static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value
 
 static void put_handshake_usb(struct ft1000_device *ft1000dev,u16 handshake_value)
 {
-   int i;
+	int i;
 
         for (i=0; i<1000; i++);
 }
-- 
1.7.1

