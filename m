Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1KDSW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:22:56 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:53648 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933077Ab1KDSWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:22:55 -0400
Message-ID: <4EB42D51.50100@xenotime.net>
Date: Fri, 04 Nov 2011 11:22:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>
Subject: [PATCH 2/8] Documentation: thinkpad-acpi grammo fixes
References: <4EB423D8.9030102@xenotime.net>
In-Reply-To: <4EB423D8.9030102@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>

This commit adds minor grammatical fixes to the description of the
keys in the thinkpad-acpi documentation.

Signed-off-by: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/laptops/thinkpad-acpi.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx1104.orig/Documentation/laptops/thinkpad-acpi.txt
+++ lnx1104/Documentation/laptops/thinkpad-acpi.txt
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
