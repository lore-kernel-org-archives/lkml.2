Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab0GUFNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:13:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762179Ab0GUEzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CtJ7MhDHtTp/Mpt0YPClegMH2oatvSWDSdI/cLL0KtWVN60pLvKFyZAgT+l91cwo20
         OdxG82Kq8ew3OduaAozL+Y+lMOF/5XeBH0Vjhshj8JzWwKhsUCSU2h6dwxRHW/7xhhRL
         64Q30pNgiV6c3+Twve9wpV1SB3nqeoE5Lcolk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 68/68]Documentation/laptops/acer-wmi.txt update web address.
Date: Tue, 20 Jul 2010 21:54:49 -0700
Message-Id: <1279688096-29519-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates abroken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/laptops/acer-wmi.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/laptops/acer-wmi.txt b/Documentation/laptops/acer-wmi.txt
index 0768fcc..4beafa6 100644
--- a/Documentation/laptops/acer-wmi.txt
+++ b/Documentation/laptops/acer-wmi.txt
@@ -173,7 +173,7 @@ Credits
 *******
 
 Olaf Tauber, who did the real hard work when he developed acerhk
-http://www.informatik.hu-berlin.de/~tauber/acerhk
+http://www.cakey.de/acerhk/
 All the authors of laptop ACPI modules in the kernel, whose work
 was an inspiration in the early days of acer_acpi
 Mathieu Segaud, who solved the problem with having to modprobe the driver
-- 
1.7.1.rc1.21.gf3bd6

