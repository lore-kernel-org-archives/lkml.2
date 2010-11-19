Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0KSFuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 00:50:17 -0500
Received: from ebb05.tieto.com ([131.207.168.36]:53270 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab0KSFuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 00:50:16 -0500
X-AuditID: 83cfa824-b7c8aae000005f9b-6f-4ce610169e57
Message-ID: <4CE6111F.5070303@tieto.com>
Date: Fri, 19 Nov 2010 13:54:39 +0800
From: Yang Rui Rui <ruirui.r.yang@tieto.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] docs: INSTALL_HDR_PATH fix
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INSTALL_HDR_PATH example in documentation is wrong.
it should be a prefix like /usr

Signed-off-by: Yang Ruirui<ruirui.r.yang@tieto.com>
---
  Documentation/make/headers_install.txt |    4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.37-rc2.orig/Documentation/make/headers_install.txt	2010-11-16 10:31:02.000000000 +0800
+++ linux-2.6.37-rc2/Documentation/make/headers_install.txt	2010-11-19 12:30:09.000000000 +0800
@@ -24,7 +24,7 @@ The "make headers_install" command can b
  kernel source code (or using a standard out-of-tree build).  It takes two
  optional arguments:
  
-  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr/include
+  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr
  
  ARCH indicates which architecture to produce headers for, and defaults to the
  current architecture.  The linux/asm directory of the exported kernel headers
@@ -34,7 +34,7 @@ the command:
    ls -d include/asm-* | sed 's/.*-//'
  
  INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
-"./usr/include".
+"./usr".
  
  The command "make headers_install_all" exports headers for all architectures
  simultaneously.  (This is mostly of interest to distribution maintainers,

-- 
To adhere means to yield. To yield means to adhere.
