Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2BMJK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:10:56 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:35749 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2BMJKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:10:54 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: rdunlap@xenotime.net, trivial@kernel.org, lucas.demarchi@profusion.mobi,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 2/2] [trivial] Documentation: broken URL in libata
Date: Mon, 13 Feb 2012 10:09:52 +0100
Message-Id: <1329124192-27461-3-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1329124192-27461-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1329124192-27461-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix broken link to license text:
http://www.opensource.org/licenses/osl-1.1.txt
The text for version 1.1 of the Open Sofware license doesn't seem
to be available anywhere on http://www.opensource.org/ any more.
Replace it with a snapshot from the Internet Wayback Machine.

I first thought about hosting a copy of this file on my
own website, but my website has less authority than
an explicit backup of the original location.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 Documentation/DocBook/libata.tmpl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/libata.tmpl b/Documentation/DocBook/libata.tmpl
index cdd1bb9..bda33c1 100644
--- a/Documentation/DocBook/libata.tmpl
+++ b/Documentation/DocBook/libata.tmpl
@@ -22,8 +22,8 @@
    <para>
    The contents of this file are subject to the Open
    Software License version 1.1 that can be found at
-   <ulink url="http://www.opensource.org/licenses/osl-1.1.txt">http://www.opensource.org/licenses/osl-1.1.txt</ulink> and is included herein
-   by reference.
+   <ulink url="http://web.archive.org/web/20060924133258/http://www.opensource.org/licenses/osl-1.1.txt">http://web.archive.org/web/20060924133258/http://www.opensource.org/licenses/osl-1.1.txt</ulink>
+   and is included herein by reference.
    </para>
 
    <para>
-- 
1.7.4.1

