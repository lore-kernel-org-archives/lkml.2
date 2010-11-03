Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0KCKSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:18:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63762 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab0KCKSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=c4FaNdkyoYPo9JpvXKPPWN9kvL58E4vhx9iMJAEubG+cJd/pL8CisoqBv7btooADoF
         Y39A4oI0WsqFE2bLZTSI23VAMWeoDVWPMLNm/03pG6HPS96PAKbHh0O+PgB/g2YYdh8B
         j31af7Ml4OjaNyfWgIv3RHtNW+03hcvZ5xij4=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 5/9] staging: ft1000: Get rid of PULONG typedef usage.
Date: Wed,  3 Nov 2010 11:19:51 +0100
Message-Id: <1288779595-15793-5-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
References: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 2e48686..bc00223 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -100,7 +100,6 @@ struct prov_record {
 
 #define ULONG               u32 /* WTF ??? */
 #define BOOLEAN             u8
-#define PULONG              u32 *
 #define PCHAR               u8 *
 #define UINT                u32
 
-- 
1.7.1

