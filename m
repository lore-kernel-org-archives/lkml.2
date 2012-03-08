Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2CHEzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:55:01 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:49401 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2CHEy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:54:58 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: rdunlap@xenotime.net, trivial@kernel.org, lucas.demarchi@profusion.mobi,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH RESEND] [trivial] Documentation: broken URL in libata
Date: Thu,  8 Mar 2012 05:53:56 +0100
Message-Id: <1331182436-32438-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The text for version 1.1 of the Open Sofware license doesn't seem
to be available anywhere on http://www.opensource.org/ any more.
Replace it with an URL on fedora.org.

Thanks to Randy Dunlap for his advise choosing the most
appropriate replacement URL.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 Documentation/DocBook/libata.tmpl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/libata.tmpl b/Documentation/DocBook/libata.tmpl
index cdd1bb9..880c956 100644
--- a/Documentation/DocBook/libata.tmpl
+++ b/Documentation/DocBook/libata.tmpl
@@ -22,8 +22,8 @@
    <para>
    The contents of this file are subject to the Open
    Software License version 1.1 that can be found at
-   <ulink url="http://www.opensource.org/licenses/osl-1.1.txt">http://www.opensource.org/licenses/osl-1.1.txt</ulink> and is included herein
-   by reference.
+   <ulink url="http://fedoraproject.org/wiki/Licensing:OSL1.1">http://fedoraproject.org/wiki/Licensing:OSL1.1</ulink>
+   and is included herein by reference.
    </para>
 
    <para>
-- 
1.7.4.1

