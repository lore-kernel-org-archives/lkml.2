Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2BITtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:49:32 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43855 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758496Ab2BITt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:49:29 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        e1000-devel@lists.sourceforge.net, Neil Horman <nhorman@tuxdriver.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH v2 0/2] Part 1: handle addr_assign_type for random addresses
Date: Thu,  9 Feb 2012 20:48:52 +0100
Message-Id: <1328816934-11508-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328816968;53a409b9;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated and split up version of my patch series to
fix the handling of addr_assign_type for random MAC addresses.

The first part contains the basic changes in etherdevice.h
and eth.c incl. needed adaptations in the existing code

Danny Kukawka (2):
  eth: reset addr_assign_type if eth_mac_addr() called
  rename dev_hw_addr_random and remove redundant second

 drivers/net/ethernet/intel/igbvf/netdev.c         |   11 +++++---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   28 ++++++++++++--------
 include/linux/etherdevice.h                       |   13 +++++----
 net/ethernet/eth.c                                |    2 +
 4 files changed, 33 insertions(+), 21 deletions(-)

-- 
1.7.7.3

