Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab0EUSaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:30:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33782 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628Ab0EUSa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:30:28 -0400
Date: Fri, 21 May 2010 11:29:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, Amerigo Wang <amwang@redhat.com>
Subject: [PATCH] sysctl: fix kernel-doc notation and typos
Message-Id: <20100521112953.91a7cb7e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090209.4BF6D132.0012:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings, kernel-doc special characters, and
typos in recent kernel/sysctl.c additions.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Amerigo Wang <amwang@redhat.com>
---
 kernel/sysctl.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- linux-2.6.34-git6.orig/kernel/sysctl.c
+++ linux-2.6.34-git6/kernel/sysctl.c
@@ -2083,20 +2083,20 @@ static void proc_skip_char(char **buf, s
 
 #define TMPBUFLEN 22
 /**
- * proc_get_long - reads an ASCII formated integer from a user buffer
+ * proc_get_long - reads an ASCII formatted integer from a user buffer
  *
- * @buf - a kernel buffer
- * @size - size of the kernel buffer
- * @val - this is where the number will be stored
- * @neg - set to %TRUE if number is negative
- * @perm_tr - a vector which contains the allowed trailers
- * @perm_tr_len - size of the perm_tr vector
- * @tr - pointer to store the trailer character
- *
- * In case of success 0 is returned and buf and size are updated with
- * the amount of bytes read. If tr is non NULL and a trailing
- * character exist (size is non zero after returning from this
- * function) tr is updated with the trailing character.
+ * @buf: a kernel buffer
+ * @size: size of the kernel buffer
+ * @val: this is where the number will be stored
+ * @neg: set to %TRUE if number is negative
+ * @perm_tr: a vector which contains the allowed trailers
+ * @perm_tr_len: size of the perm_tr vector
+ * @tr: pointer to store the trailer character
+ *
+ * In case of success %0 is returned and @buf and @size are updated with
+ * the amount of bytes read. If @tr is non-NULL and a trailing
+ * character exists (size is non-zero after returning from this
+ * function), @tr is updated with the trailing character.
  */
 static int proc_get_long(char **buf, size_t *size,
 			  unsigned long *val, bool *neg,
@@ -2147,15 +2147,15 @@ static int proc_get_long(char **buf, siz
 }
 
 /**
- * proc_put_long - coverts an integer to a decimal ASCII formated string
+ * proc_put_long - converts an integer to a decimal ASCII formatted string
  *
- * @buf - the user buffer
- * @size - the size of the user buffer
- * @val - the integer to be converted
- * @neg - sign of the number, %TRUE for negative
+ * @buf: the user buffer
+ * @size: the size of the user buffer
+ * @val: the integer to be converted
+ * @neg: sign of the number, %TRUE for negative
  *
- * In case of success 0 is returned and buf and size are updated with
- * the amount of bytes read.
+ * In case of success %0 is returned and @buf and @size are updated with
+ * the amount of bytes written.
  */
 static int proc_put_long(void __user **buf, size_t *size, unsigned long val,
 			  bool neg)
