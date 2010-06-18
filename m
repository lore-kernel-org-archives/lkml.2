Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0FRWgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 18:36:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57867 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab0FRWgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:36:53 -0400
Date: Fri, 18 Jun 2010 15:34:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org
Subject: [PATCH -next] netfilter: xt_IDLETIMER needs kdev_t.h
Message-Id: <20100618153455.dd33948b.randy.dunlap@oracle.com>
In-Reply-To: <20100618145443.77b7f8df.sfr@canb.auug.org.au>
References: <20100618145443.77b7f8df.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4C1BF501.00B4:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add header file to fix build error:
net/netfilter/xt_IDLETIMER.c:276: error: implicit declaration of function 'MKDEV'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/netfilter/xt_IDLETIMER.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100618.orig/net/netfilter/xt_IDLETIMER.c
+++ linux-next-20100618/net/netfilter/xt_IDLETIMER.c
@@ -36,6 +36,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_IDLETIMER.h>
+#include <linux/kdev_t.h>
 #include <linux/kobject.h>
 #include <linux/workqueue.h>
 #include <linux/sysfs.h>
