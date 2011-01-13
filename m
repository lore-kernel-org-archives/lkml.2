Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab1AMWCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:02:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55778 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1AMWCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:02:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=DLywueamdetfkOtTsiXxEqhuWnEGuMG1Yke7qHWOXqiF9ZbDWxpU2IjdPFw5A4EHYm
         I7+9ABIzrOVtk9cPVwfMHst4WypXN5gvfqhoEZgNea6FuKx+AFxxXIGY7hQuF1tCjWO0
         bJNXNPzPPZLiJ3eqZX+06fKTkCWK/3yTvGTOQ=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net> (maintainer:DOCUMENTATION),
        Milan Broz <mbroz@redhat.com> (commit_signer:1/3=33%),
        Andrea Gelmini <andrea.gelmini@gelma.net> (commit_signer:1/3=33%),
        Thomas Weber <weber@corscience.de> (commit_signer:1/3=33%),
        Mike Frysinger <vapier.adi@gmail.com> (commit_signer:1/3=33%),
        Jiri Kosina <jkosina@suse.cz> (commit_signer:1/3=33%),
        dm-devel@redhat.com (open list:DEVICE-MAPPER (LVM)),
        linux-kernel@vger.kernel.org (open list)
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] Documentation: dm-crypt: update cryptsetup homepage
Date: Thu, 13 Jan 2011 23:01:53 +0100
Message-Id: <1294956113-6630-1-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.4.rc1.85.g84645
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 Documentation/device-mapper/dm-crypt.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index 59293ac..6b5c42d 100644
--- a/Documentation/device-mapper/dm-crypt.txt
+++ b/Documentation/device-mapper/dm-crypt.txt
@@ -41,7 +41,7 @@ Example scripts
 ===============
 LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
 encryption with dm-crypt using the 'cryptsetup' utility, see
-http://clemens.endorphin.org/cryptography
+http://code.google.com/p/cryptsetup/
 
 [[
 #!/bin/sh
-- 
1.7.4.rc1.85.g84645

