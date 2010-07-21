Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762353Ab0GUFJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:09:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379Ab0GUE4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tCq7qRS+w2WgJXxopOwHGJA7kSVp7vJuSFSnUB0HIMakAqt5d8uvHui8nvBH3fP7u7
         La8p0QoUrqkOoMDHnvjlMw7NIPAtZ1lChgDtgZ+IJhkdJ5PCR8Ho+UkBL/9tSugKuoUl
         XLnTotVYha6z+Gu7w0+wUJ6026XVbe8DbNb7o=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 91/91]Documentation/power/apm-acpi.txt update web address.
Date: Tue, 20 Jul 2010 21:56:41 -0700
Message-Id: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/power/apm-acpi.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/power/apm-acpi.txt b/Documentation/power/apm-acpi.txt
index 1bd799d..6cc423d 100644
--- a/Documentation/power/apm-acpi.txt
+++ b/Documentation/power/apm-acpi.txt
@@ -28,5 +28,5 @@ and be sure that they are started sometime in the system boot process.
 Go ahead and start both.  If ACPI or APM is not available on your
 system the associated daemon will exit gracefully.
 
-  apmd:   http://worldvisions.ca/~apenwarr/apmd/
+  apmd:   http://ftp.debian.org/pool/main/a/apmd/
   acpid:  http://acpid.sf.net/
-- 
1.7.1.rc1.21.gf3bd6

