Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283Ab0GSJEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 05:04:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:10589 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760264Ab0GSJEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 05:04:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,226,1278313200"; 
   d="scan'208";a="536788209"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] memrar: Updated maintainer contact information
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 19 Jul 2010 09:32:39 +0100
Message-ID: <20100719083233.7357.34606.stgit@localhost.localdomain>
In-Reply-To: <20100719083212.7357.28472.stgit@localhost.localdomain>
References: <20100719083212.7357.28472.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ossama Othman <ossama.othman@intel.com>

Signed-off-by: Ossama Othman <ossama.othman@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/memrar/TODO       |    2 +-
 drivers/staging/memrar/memrar-abi |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/staging/memrar/TODO b/drivers/staging/memrar/TODO
index 0087447..435e09b 100644
--- a/drivers/staging/memrar/TODO
+++ b/drivers/staging/memrar/TODO
@@ -1,7 +1,7 @@
 RAR Handler (memrar) Driver TODO Items
 ======================================
 
-Maintainer: Ossama Othman <ossama.othman@intel.com>
+Maintainer: Eugene Epshteyn <eugene.epshteyn@intel.com>
 
 memrar.h
 --------
diff --git a/drivers/staging/memrar/memrar-abi b/drivers/staging/memrar/memrar-abi
index 98a6bb1..c23fc99 100644
--- a/drivers/staging/memrar/memrar-abi
+++ b/drivers/staging/memrar/memrar-abi
@@ -1,7 +1,7 @@
 What:		/dev/memrar
 Date:		March 2010
-KernelVersion:	Kernel version this feature first showed up in.
-Contact:	Ossama Othman <ossama.othman@intel.com>
+KernelVersion:	2.6.34
+Contact:	Eugene Epshteyn <eugene.epshteyn@intel.com>
 Description:	The Intel Moorestown Restricted Access Region (RAR)
 		Handler driver exposes an ioctl() based interface that
 		allows a user to reserve and release blocks of RAR

