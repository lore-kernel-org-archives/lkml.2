Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab1HWPV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:21:26 -0400
Received: from ironclad.mail.utexas.edu ([146.6.25.7]:41645 "EHLO
	ironclad.mail.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab1HWPVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:21:22 -0400
X-IronPort-MID: 121131828
X-Utexas-Seen-Inbound: true
Date: Tue, 23 Aug 2011 10:11:49 -0500
From: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>,
        Kumar Appaiah <a.kumar@alumni.iitm.ac.in>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] thinkpad-acpi: minor grammatical fixes to documentation
Message-ID: <20110823151149.GA7495@bluemoon.ece.utexas.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-OS: Linux aceslinc 2.6.32-bpo.5-amd64 x86_64
X-Operating-System: Linux aceslinc 2.6.32-bpo.5-amd64 x86_64
X-Editor: GNU Emacs 24.0.50.1
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds minor grammatical fixes to the description of the
keys in the thinkpad-acpi documentation.

Signed-off-by: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>
---
 Documentation/laptops/thinkpad-acpi.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 6181548..b73dcea 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -411,9 +411,9 @@ event	code	Key		Notes
 
 0x1004	0x03	FN+F4		Sleep button (ACPI sleep button
 				semantics, i.e. sleep-to-RAM).
-				It is always generate some kind
+				It always generates some kind
 				of event, either the hot key
-				event or a ACPI sleep button
+				event or an ACPI sleep button
 				event. The firmware may
 				refuse to generate further FN+F4
 				key presses until a S3 or S4 ACPI
-- 
1.7.2.5
