Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2BVMhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:37:05 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:44666 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368Ab2BVMhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:37:03 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: David Dillow <dave@thedillows.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Sergey Lapin <slapin@ossfans.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] reuse eth_mac_addr()
Date: Wed, 22 Feb 2012 13:36:37 +0100
Message-Id: <1329914199-30862-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329914223;e10f65af;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches to remove custom .ndo_set_mac_address methodes
and use eth_mac_addr() instead since these functions to the 
same as eth_mac_addr(). 

An advantage of this change: eth_mac_addr() already
checks if the given mac address is valid. 

Danny Kukawka (2):
  3com/typhoon: reuse eth_mac_addr()
  net/ieee802154/6lowpan.c: reuse eth_mac_addr()

 drivers/net/ethernet/3com/typhoon.c |   14 +-------------
 net/ieee802154/6lowpan.c            |   16 ++--------------
 2 files changed, 3 insertions(+), 27 deletions(-)

-- 
1.7.8.3

