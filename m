Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab1E0Vfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:35:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60499 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab1E0Vfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:35:50 -0400
Date: Fri, 27 May 2011 14:34:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH] lib: fix bitmap.c kernel-doc notation
Message-Id: <20110527143412.397da46e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DE01933.0086:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc warnings in lib/bitmap.c:

Warning(lib/bitmap.c:596): No description found for parameter 'buf'
Warning(lib/bitmap.c:596): Excess function parameter 'bp' description in '__bitmap_parselist'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 lib/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.39-git14.orig/lib/bitmap.c
+++ linux-2.6.39-git14/lib/bitmap.c
@@ -572,7 +572,7 @@ EXPORT_SYMBOL(bitmap_scnlistprintf);
 
 /**
  * __bitmap_parselist - convert list format ASCII string to bitmap
- * @bp: read nul-terminated user string from this buffer
+ * @buf: read nul-terminated user string from this buffer
  * @buflen: buffer size in bytes.  If string is smaller than this
  *    then it must be terminated with a \0.
  * @is_user: location of buffer, 0 indicates kernel space
