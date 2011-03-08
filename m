Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab1CHVuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:50:04 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:35959 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab1CHVuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:50:02 -0500
Date: Tue, 8 Mar 2011 22:49:19 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH R4 5/7] xen/balloon: Minor notation fixes
Message-ID: <20110308214919.GF27331@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor notation fixes.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 drivers/xen/balloon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 6bae013..431e9f0 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -592,11 +592,11 @@ static struct attribute *balloon_info_attrs[] = {
 
 static struct attribute_group balloon_info_group = {
 	.name = "info",
-	.attrs = balloon_info_attrs,
+	.attrs = balloon_info_attrs
 };
 
 static struct sysdev_class balloon_sysdev_class = {
-	.name = BALLOON_CLASS_NAME,
+	.name = BALLOON_CLASS_NAME
 };
 
 static int register_balloon(struct sys_device *sysdev)
-- 
1.5.6.5
