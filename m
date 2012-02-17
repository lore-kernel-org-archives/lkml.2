Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2BQUPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:15:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60903 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2BQUPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:15:32 -0500
MIME-Version: 1.0
From: Sebastiaan de Haan <sebastiaan@sebastiaandehaan.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sebastiaan de Haan <sebastiaan@sebastiaandehaan.org>
Subject: [PATCH] staging: wlan-ng: p80211netdev.c: fixed checkpatch error
Date: Fri, 17 Feb 2012 21:14:55 +0100
Message-Id: <1329509695-9417-1-git-send-email-sebastiaan@sebastiaandehaan.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New kernel developer inspired by the 2010 FOSDEM talk. Running checkpatch on
p80211netdev.c gave the error: p80211netdev.c:153: ERROR: "foo * bar" should
be "foo *bar". Fixed it by doing what was suggested.

Signed-off-by: Sebastiaan de Haan <sebastiaan@sebastiaandehaan.org>
---
 drivers/staging/wlan-ng/p80211netdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 14bfeb2..0f51b4a 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -150,7 +150,7 @@ static int p80211knetdev_init(netdevice_t *netdev)
 * Returns:
 *	the address of the statistics structure
 ----------------------------------------------------------------*/
-static struct net_device_stats *p80211knetdev_get_stats(netdevice_t * netdev)
+static struct net_device_stats *p80211knetdev_get_stats(netdevice_t *netdev)
 {
 	wlandevice_t *wlandev = netdev->ml_priv;
 
-- 
1.7.2.5

