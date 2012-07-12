Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162540Ab2GLXYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:24:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58924 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934329Ab2GLXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Micha=A9=A9=20Miros=A9=A9aw?= <mirq-linux@rere.qmqm.pl>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=2009/68=5D=20ethtool=3A=20allow=20ETHTOOL=5FGSSET=5FINFO=20for=20users?=
Date: Thu, 12 Jul 2012 16:01:43 -0700
Message-Id: <20120712175036.238441302@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>

[ Upstream commit f80400a26a2e8bff541de12834a1134358bb6642 ]

Allow ETHTOOL_GSSET_INFO ethtool ioctl() for unprivileged users.
ETHTOOL_GSTRINGS is already allowed, but is unusable without this one.

Signed-off-by: Micha©© Miros©©aw <mirq-linux@rere.qmqm.pl>
Acked-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/ethtool.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1964,6 +1964,7 @@ int dev_ethtool(struct net *net, struct
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_GSG:
+	case ETHTOOL_GSSET_INFO:
 	case ETHTOOL_GSTRINGS:
 	case ETHTOOL_GTSO:
 	case ETHTOOL_GPERMADDR:


