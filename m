Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab0DNQp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:45:29 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:56454 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab0DNQp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:45:27 -0400
Date: Wed, 14 Apr 2010 09:43:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-rdma@vger.kernel.org, rolandd@cisco.com, peterz@infradead.org,
       pavel@ucw.cz, mingo@elte.hu
Subject: [PATCH] ummunotify: fix umn-test build
Message-Id: <20100414094341.ba69842d.randy.dunlap@oracle.com>
In-Reply-To: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BC5F0D3.00FC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add ummunotify.h to Kbuild list for export to userspace,
fixing 27 build errors in umn-test.c when O=builddir is used.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

maybe another item to add to SubmitChecklist :(


--- lnx-2634-rc4.orig/include/linux/Kbuild
+++ lnx-2634-rc4/include/linux/Kbuild
@@ -163,6 +163,7 @@ header-y += tipc_config.h
 header-y += toshiba.h
 header-y += udf_fs_i.h
 header-y += ultrasound.h
+header-y += ummunotify.h
 header-y += un.h
 header-y += utime.h
 header-y += veth.h
