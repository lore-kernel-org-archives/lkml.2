Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609Ab0GUFAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:00:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61571 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556Ab0GUE7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dlf5ni+awdLN1nq61dLEFp+aK2i87up0U8bzFuleo8EraClA9k/GHM0IsiqSoi74PE
         cLegz1fqxeiZcGqM+Y0KuVzmN1X5iBtvNHDdVGMh+GyFS3TP7ty6WXHBDyPsntslIDt8
         2m2p+eCxQtOKV2B3F22CH3CL6xvvvAkAG9pwI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 130/130]Documentation/video4linux/bttv/Cards update web address.
Date: Tue, 20 Jul 2010 21:58:47 -0700
Message-Id: <1279688336-29735-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes some web addresses in of which
I have no clue on where to find them, and also updates
an address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/video4linux/bttv/Cards |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/video4linux/bttv/Cards b/Documentation/video4linux/bttv/Cards
index d338965..12217fc 100644
--- a/Documentation/video4linux/bttv/Cards
+++ b/Documentation/video4linux/bttv/Cards
@@ -802,7 +802,7 @@ Kworld (www.kworld.com.tw)
 
 
 
-JTT/ Justy Corp.http://www.justy.co.jp/ (www.jtt.com.jp website down)
+JTT/ Justy Corp.(http://www.jtt.ne.jp/)
 ---------------------------------------------------------------------
    JTT-02 (JTT TV) "TV watchmate pro" (bt848)
 
@@ -828,7 +828,7 @@ Eline www.eline-net.com/
    Eline Vision TVMaster / TVMaster FM (ELV-TVM/ ELV-TVM-FM) = LR26  (bt878)
    Eline Vision TVMaster-2000 (ELV-TVM-2000, ELV-TVM-2000-FM)= LR138 (saa713x)
 
-Spirit http://www.spiritmodems.com.au/
+Spirit 
 ------
    Spirit TV Tuner/Video Capture Card (bt848)
 
@@ -959,6 +959,6 @@ Asus www.asuscom.com
 
 Hoontech
 --------
-http://www.hoontech.com/korean/download/down_driver_list03.html
+http://www.hoontech.de/
    HART Vision 848 (H-ART Vision 848)
    HART Vision 878 (H-Art Vision 878)
-- 
1.7.1.rc1.21.gf3bd6

