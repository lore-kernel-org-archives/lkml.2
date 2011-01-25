Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1AYLbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:31:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1AYLa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:30:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=BXJ/GIiuSEIsW3y2aPUOI9tZiVeGjwV0jA13oU6V6/1TWRuEy3MZHl0EZLCVs+pPG+
         MLOAhZOUJ9We7qBG6kyzjk2QhYJeGX6OkWLAbSJ4jWq43gFZUiiFMY41+A8iOulBDcPs
         AzQesaikZRgLvMGoPDeYCznok3/tkjug8UvEg=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH resend 06/12] staging: ft1000: Fix coding style in put_handshake_usb() function.
Date: Tue, 25 Jan 2011 12:31:17 +0100
Message-Id: <1295955083-11086-6-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

