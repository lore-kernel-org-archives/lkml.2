Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1FFQIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:08:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36975 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1FFQIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jpZ6DfE0VRP7Qn8h9UiOpRqj5+duYGqiXXm6O5y8Z/tV8m6Nn3l19nodyI36VmYt9i
         r+VNES476luO35X/omQ3I5dEsvkC7mypsjlwKsnHLCeBPZRZ5ZLTCvjf1aftd1CBkuDA
         90k9yrxpjnEWXtOlBC7a6y23x/BYHpfVzzBQ8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]Documentation:i2o:ioctl Fix typo Settting.
Date: Mon,  6 Jun 2011 09:08:10 -0700
Message-Id: <1307376490-2781-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes a typo "Settting" to "Setting".
Note: I might have sent something similar, but looking through
my archives I dont see anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/i2o/ioctl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/i2o/ioctl b/Documentation/i2o/ioctl
index 1e77fac..22ca53a 100644
--- a/Documentation/i2o/ioctl
+++ b/Documentation/i2o/ioctl
@@ -110,7 +110,7 @@ V. Getting Logical Configuration Table
       ENOBUFS     Buffer not large enough.  If this occurs, the required
                   buffer length is written into *(lct->reslen)
 
-VI. Settting Parameters
+VI. Setting Parameters
 
    SYNOPSIS
 
-- 
1.7.5.2

