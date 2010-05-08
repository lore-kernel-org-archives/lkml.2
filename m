Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0EHB6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 21:58:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:60264 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab0EHB6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 21:58:23 -0400
Date: Sat, 8 May 2010 01:58:00 GMT
From: tip-bot for Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, ksrinivasan@novell.com, hpa@zytor.com,
       mingo@redhat.com, hjanssen@microsoft.com, gregkh@suse.de,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, ksrinivasan@novell.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de, hjanssen@microsoft.com,
       tglx@linutronix.de
In-Reply-To: <20100507235541.GA15448@kroah.com>
References: <20100507235541.GA15448@kroah.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, HyperV: fix up the license to mshyperv.c
Message-ID: <tip-9fa02317429449e8176c9bb6da3ac00eb14d52d3@git.kernel.org>
Git-Commit-ID: 9fa02317429449e8176c9bb6da3ac00eb14d52d3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 01:58:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fa02317429449e8176c9bb6da3ac00eb14d52d3
Gitweb:     http://git.kernel.org/tip/9fa02317429449e8176c9bb6da3ac00eb14d52d3
Author:     Greg Kroah-Hartman <gregkh@suse.de>
AuthorDate: Fri, 7 May 2010 16:55:41 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 7 May 2010 17:00:25 -0700

x86, HyperV: fix up the license to mshyperv.c

This should have been GPLv2 only, we cut and pasted from the wrong file
originally, sorry.

Also removed some unneeded boilerplate license code, we all know where
to find the GPLv2, and that there's no warranty as that is implicit from
the license.

Cc: Ky Srinivasan <ksrinivasan@novell.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
LKML-Reference: <20100507235541.GA15448@kroah.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mshyperv.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 2443b61..a58d8e6 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -6,18 +6,7 @@
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ * the Free Software Foundation; version 2 of the License.
  *
  */
 
