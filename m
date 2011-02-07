Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1BGEk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 23:40:28 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37526 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1BGEkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 23:40:23 -0500
Date: Sun, 6 Feb 2011 20:40:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH] Documentation: log_buf_len accepts [KMG]
Message-Id: <20110206204002.2f3eab4e.randy.dunlap@oracle.com>
In-Reply-To: <20110206174504.GA23024@laptop>
References: <20110206174504.GA23024@laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D4F77B3.0095:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update the "log_buf_len" description to use [KMG] syntax for the
buffer size.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-next-20110204.orig/Documentation/kernel-parameters.txt
+++ linux-next-20110204/Documentation/kernel-parameters.txt
@@ -1262,10 +1262,9 @@ and is between 256 and 4096 characters. 
 			6 (KERN_INFO)		informational
 			7 (KERN_DEBUG)		debug-level messages
 
-	log_buf_len=n	Sets the size of the printk ring buffer, in bytes.
-			Format: { n | nk | nM }
-			n must be a power of two.  The default size
-			is set in the kernel config file.
+	log_buf_len=n[KMG]	Sets the size of the printk ring buffer,
+			in bytes.  n must be a power of two.  The default
+			size is set in the kernel config file.
 
 	logo.nologo	[FB] Disables display of the built-in Linux logo.
 			This may be used to provide more screen space for
