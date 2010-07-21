Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300Ab0GUE7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:59:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51220 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933536Ab0GUE7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PFRfpWCiQO+yC+i4qKtF6OZ3f5JTm1VV8ACY93lLwd5i2YCfFTA8ekZoEwVIahToHY
         lRwkkJpX0zqV8Y7j2oDYa+6/+q8Y3iPzM5qstN9Q6dL+KoxLPgGl+TyMGjTyWr2zuYNz
         AXEcHKwwA2vXbPkn4N9sLbUxLgQvnFuN+ooOM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 126/126]Documentation/video4linux/CQcam.txt update web address.
Date: Tue, 20 Jul 2010 21:58:43 -0700
Message-Id: <1279688336-29735-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/video4linux/CQcam.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/video4linux/CQcam.txt b/Documentation/video4linux/CQcam.txt
index d230878..8977e7c 100644
--- a/Documentation/video4linux/CQcam.txt
+++ b/Documentation/video4linux/CQcam.txt
@@ -203,11 +203,11 @@ The V4L2 API spec:
   http://v4l2spec.bytesex.org/
 
 Some web pages about the quickcams:
-   http://www.dkfz-heidelberg.de/Macromol/wedemann/mini-HOWTO-cqcam.html
+   http://www.pingouin-land.com/howto/QuickCam-HOWTO.html
 
    http://www.crynwr.com/qcpc/            QuickCam Third-Party Drivers
    http://www.crynwr.com/qcpc/re.html     Some Reverse Engineering
-   http://cse.unl.edu/~cluening/gqcam/    v4l client
+   http://www.wirelesscouch.net/software/gqcam/   v4l client
    http://phobos.illtel.denver.co.us/pub/qcread/ doesn't use v4l
    ftp://ftp.cs.unm.edu/pub/chris/quickcam/   Has lots of drivers
    http://www.cs.duke.edu/~reynolds/quickcam/ Has lots of information
-- 
1.7.1.rc1.21.gf3bd6

