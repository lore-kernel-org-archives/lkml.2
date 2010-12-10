Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0LJM7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:59:54 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:37081 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab0LJM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:59:53 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: Warn about word wrap bug in KMail
From: Lasse Collin <lasse.collin@tukaani.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 10 Dec 2010 15:00:34 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012101500.34850.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

--- linux-2.6.37-rc4.orig/Documentation/email-clients.txt	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc4/Documentation/email-clients.txt	2010-12-10 14:16:41.000000000 +0200
@@ -104,6 +104,13 @@ Then from the "Message" menu item, selec
 As an added bonus you can customise the message creation toolbar menu
 and put the "insert file" icon there.
 
+Make the the composer window wide enough so that no lines wrap. As of
+KMail 1.13.5 (KDE 4.5.4), KMail will apply word wrapping when sending
+the email if the lines wrap in the composer window. Having word wrapping
+disabled in the Options menu isn't enough. Thus, if your patch has very
+long lines, you must make the composer window very wide before sending
+the email. See: https://bugs.kde.org/show_bug.cgi?id=174034
+
 You can safely GPG sign attachments, but inlined text is preferred for
 patches so do not GPG sign them.  Signing patches that have been inserted
 as inlined text will make them tricky to extract from their 7-bit encoding.
