Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0EGXzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 19:55:51 -0400
Received: from kroah.org ([198.145.64.141]:39452 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab0EGXzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 19:55:50 -0400
Date: Fri, 7 May 2010 16:55:41 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ky Srinivasan <ksrinivasan@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Hank Janssen <hjanssen@microsoft.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alok Kataria <akataria@vmware.com>
Subject: [PATCH] HyperV: fix up the license to mshyperv.c
Message-ID: <20100507235541.GA15448@kroah.com>
References: <4BE49778.6060800@zytor.com>
 <20100507230210.GB24877@kroah.com>
 <4BE49D76.5000001@zytor.com>
 <20100507231202.GA13771@kroah.com>
 <4BE49FB6.9060206@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE49FB6.9060206@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

This should have been GPLv2 only, we cut and pasted from the wrong file
originally, sorry.

Also removed some unneeded boilerplate license code, we all know where
to find the GPLv2, and that there's no warranty as that is implicit from
the license.

Cc: Ky Srinivasan <ksrinivasan@novell.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mshyperv.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

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
 
