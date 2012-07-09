Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2GIOic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:38:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38272 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296Ab2GIOiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:21 -0400
Message-Id: <20120709143121.997850510@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 37/48] ethtool: allow ETHTOOL_GSSET_INFO for users
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit f80400a26a2e8bff541de12834a1134358bb6642 ]

Allow ETHTOOL_GSSET_INFO ethtool ioctl() for unprivileged users.
ETHTOOL_GSTRINGS is already allowed, but is unusable without this one.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/ethtool.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 2b587ec..2367246 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1672,6 +1672,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_GSG:
+	case ETHTOOL_GSSET_INFO:
 	case ETHTOOL_GSTRINGS:
 	case ETHTOOL_GTSO:
 	case ETHTOOL_GPERMADDR:


