Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab0LIPLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:11:55 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36848 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab0LIPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=IEdqWCdetAZT/icXEA4mPnSwb6WUd00i6EhBIYTL+j7Y7M+WGL96MmFA1AENLlsKu/
         nUc51+pBHDYW+IZ9pmHGSp5bO6MusPto4XwqxiQjUNUGJB/SbqqLPmo43/P6uT2WZYpo
         VaNFQz4hapki+rnGGAi2y989U6+siJlwbDnGY=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 8/8] staging: ft1000: Add file header to ft1000_proc.c
Date: Thu,  9 Dec 2010 16:13:54 +0100
Message-Id: <1291907634-22437-8-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index da706f8..0f271c2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -1,3 +1,24 @@
+/*
+ * ft1000_proc.c - ft1000 proc interface
+ *
+ * Copyright	(C) 2009-2010 Quintec
+ *		(C) 2010 Open-nandra
+ *      <marek.belisko@open-nandra.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
-- 
1.7.1

