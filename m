Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0CRRWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:22:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1822 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab0CRRWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:22:43 -0400
Subject: [PATCH v2 8/7] iw_handler.h: Use SIOCIWFIRST not SIOCSIWCOMMIT for
 offset comment
From: Joe Perches <joe@perches.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <1268932336.24544.6.camel@mj>
References: <cover.1268892663.git.joe@perches.com>
	 <b8a4d4b100a03c3f0d82eaeeb8a8e5f2efdd78d9.1268892664.git.joe@perches.com>
	 <1268932336.24544.6.camel@mj>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 10:22:40 -0700
Message-ID: <1268932960.2403.17.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 13:12 -0400, Pavel Roskin wrote:
> please change a comment referring to SIOCSIWCOMMIT in
> include/net/iw_handler.h

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index b2b98f3..3afdb21 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -323,7 +323,7 @@ typedef int (*iw_handler)(struct net_device *dev, struct iw_request_info *info,
 struct iw_handler_def {
 
 	/* Array of handlers for standard ioctls
-	 * We will call dev->wireless_handlers->standard[ioctl - SIOCSIWCOMMIT]
+	 * We will call dev->wireless_handlers->standard[ioctl - SIOCIWFIRST]
 	 */
 	const iw_handler *	standard;
 	/* Number of handlers defined (more precisely, index of the


