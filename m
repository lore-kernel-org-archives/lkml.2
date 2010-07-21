Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688Ab0GUFRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:17:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47921 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab0GUExY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jjBaVMuMRIlDNnTSzbxElb28Kr1q+ifLWavcjXP95BPFOifIH9Tw0/Jhystsq46zY0
         XZaKhM4k9qDpwYREvlDlGVQ1zcJmWDQ1v32CsBfoUttBXuDLIAyWkdbkIy0KatWH+oR/
         JjX+n1Lv7FO0Pv8XJ1hiFbPZBgMgJcisHHxqk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 43/43]Documentation/hwmon/adm1026 update web address.
Date: Tue, 20 Jul 2010 21:53:00 -0700
Message-Id: <1279687982-29413-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address to the company site
due to me being unable to locate the original content.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/adm1026 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/adm1026 b/Documentation/hwmon/adm1026
index f4327db..b19a4f9 100644
--- a/Documentation/hwmon/adm1026
+++ b/Documentation/hwmon/adm1026
@@ -6,7 +6,7 @@ Supported chips:
     Prefix: 'adm1026'
     Addresses scanned: I2C 0x2c, 0x2d, 0x2e
     Datasheet: Publicly available at the Analog Devices website
-               http://www.analog.com/en/prod/0,,766_825_ADM1026,00.html
+               http://www.analog.com/
 
 Authors:
         Philip Pokorny <ppokorny@penguincomputing.com> for Penguin Computing
-- 
1.7.1.rc1.21.gf3bd6

