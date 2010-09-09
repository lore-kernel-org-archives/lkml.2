Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab0IIW04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:26:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41812 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab0IIW0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k0HrUTbMLVMFzBD6973LV66RIgUzmDtarqYbV2W4M+5eb/AzTlB+DfsZy6Cr7/7J5e
         O14hvda5i8cJj009bbeBjMPmDSJ3pK7MpDhLw+g/7FjIkj1Xn4i/bwTiv3Mb55TCIEoL
         dNp3+m3/ecrKbaMhGFSoY95dYUcVF9pKD4UX0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 043/223]drivers/media/IR/keymaps/rc-manli.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:26:43 -0700
Message-Id: <1284071205-7756-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
References: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/IR/keymaps/rc-manli.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/keymaps/rc-manli.c b/drivers/media/IR/keymaps/rc-manli.c
index 1e9fbfa..0f590b3 100644
--- a/drivers/media/IR/keymaps/rc-manli.c
+++ b/drivers/media/IR/keymaps/rc-manli.c
@@ -13,7 +13,6 @@
 #include <media/rc-map.h>
 
 /* Michael Tokarev <mjt@tls.msk.ru>
-   http://www.corpit.ru/mjt/beholdTV/remote_control.jpg
    keytable is used by MANLI MTV00[0x0c] and BeholdTV 40[13] at
    least, and probably other cards too.
    The "ascii-art picture" below (in comments, first row
-- 
1.7.2.1

