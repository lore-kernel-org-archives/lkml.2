Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965647Ab2EOC2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:28:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42107 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965183Ab2EOC2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:28:11 -0400
MIME-Version: 1.0
Date: Tue, 15 May 2012 11:28:10 +0900
Message-ID: <CAE_PExt1Cw312HqebSU0VzxNckfKQsgdpiKh_uwiY-pV2p8VaQ@mail.gmail.com>
Subject: [PATCH] [trivial] document for max raw dev number
From: Kazuo Moriwaka <moriwaka@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documenting description about max minor number of raw devices.

Signed-off-by: Kazuo Moriwaka <moriwaka@gmail.com>

---
 Documentation/devices.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 0038318..8ae3feb 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -2421,6 +2421,8 @@ Your cooperation is appreciated.
 		  1 = /dev/raw/raw1	First raw I/O device
 		  2 = /dev/raw/raw2	Second raw I/O device
 		    ...
+		max minor number of raw device set by kernel config
+		MAX_RAW_DEVS or raw module parameter 'max_raw_devs'

 163 char

-- 
1.7.7.6


-- 
Kazuo Moriwaka
