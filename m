Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab0CRGVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 02:21:49 -0400
Received: from mail.perches.com ([173.55.12.10]:1771 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab0CRGVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 02:21:44 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Geoff Levand <geoffrey.levand@am.sony.com>, Zhu Yi <yi.zhu@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pavel Roskin <proski@gnu.org>,
       David Gibson <hermes@gibson.dropbear.id.au>,
       Corey Thomas <coreythomas@charter.net>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "David S. Miller" <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       orinoco-devel@lists.sourceforge.net
Subject: [PATCH v2 0/7] wireless: Use macros from wireless.h
Date: Wed, 17 Mar 2010 23:21:33 -0700
Message-Id: <cover.1268892663.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the STD_IW_HANDLER macro from orinoco to wireless.h
Use the wireless.h macros in various wireless files
Remove local #defines of IW_IOCTL

Joe Perches (7):
  wireless.h: Add STD_IW_HANDLER macro
  net/wireless/wext_core.c: Use IW_IOCTL_IDX macro
  net/wireless/wext-core.c: Use IW_EVENT_IDX macro
  drivers/net/wireless: Use STD_IW_HANDLER macro
  drivers/net: Remove local #define IW_IOCTL, use STD_IW_HANDLER
  orinoco/wext.c: Remove local #define STD_IW_HANDLER
  wireless.h: Use SIOCIWFIRST not SIOCSIWCOMMIT for range check

 drivers/net/ps3_gelic_wireless.c       |   35 ++++----
 drivers/net/wireless/ipw2x00/ipw2200.c |   83 ++++++++++----------
 drivers/net/wireless/orinoco/wext.c    |    2 -
 drivers/net/wireless/ray_cs.c          |   40 +++++-----
 drivers/net/wireless/wl3501_cs.c       |   52 ++++++------
 include/linux/wireless.h               |    4 +-
 net/wireless/wext-core.c               |  134 ++++++++++++++++----------------
 7 files changed, 174 insertions(+), 176 deletions(-)

