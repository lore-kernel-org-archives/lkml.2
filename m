Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab0LIVce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:32:34 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:40684 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098Ab0LIVcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:32:33 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] Input: include MT library as source for kerneldoc
Date: Thu,  9 Dec 2010 22:32:13 +0100
Message-Id: <1291930333-10017-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PQo63-0003YE-5G.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PQo63-0003YE-5G 510125b5fe2d62fced85d0cb70eac664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 Documentation/DocBook/device-drivers.tmpl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 22edcbb..35447e0 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -304,6 +304,10 @@ X!Idrivers/video/console/fonts.c
 !Edrivers/input/ff-core.c
 !Edrivers/input/ff-memless.c
      </sect1>
+     <sect1><title>Multitouch Library</title>
+!Iinclude/linux/input/mt.h
+!Edrivers/input/input-mt.c
+     </sect1>
      <sect1><title>Polled input devices</title>
 !Iinclude/linux/input-polldev.h
 !Edrivers/input/input-polldev.c
-- 
1.7.1

