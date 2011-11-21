Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1KUXUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:20:13 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:50670 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab1KUXUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:20:11 -0500
From: David Decotigny <david.decotigny@google.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Decotigny <david.decotigny@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH net-next v1 0/4] e1000e: ethtool setfeatures fixes + loopback
Date: Mon, 21 Nov 2011 15:19:56 -0800
Message-Id: <cover.1321917278.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes a bug in ethtool setfeatures and adds loopback
support through ethtool setfeatures.

I believe these patches could easily be adapted to e1000, but I don't
have the hardware to test.

############################################
# Patch Set Summary:

David Decotigny (2):
  net-e1000e: fix ethtool set_features taking new features into account
    too late
  net-e1000e: enable ethtool loopback support

Maciej Żenczykowski (2):
  net-e1000e: reworked carrier detection logic
  net-e1000e: Report carrier in loopback mode

 drivers/net/ethernet/intel/e1000e/e1000.h   |    2 +
 drivers/net/ethernet/intel/e1000e/ethtool.c |    6 +-
 drivers/net/ethernet/intel/e1000e/netdev.c  |   31 ++++++++++--
 drivers/net/ethernet/intel/e1000e/phy.c     |   69 +++++++++++++++++----------
 4 files changed, 76 insertions(+), 32 deletions(-)

-- 
1.7.3.1

