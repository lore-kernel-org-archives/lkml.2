Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2GRQup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:50:45 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:32286 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2GRQuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:50:40 -0400
Message-ID: <201207181650.q6IGodZ7007565@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sun, 1 Jul 2012 14:43:47 -0400
Subject: [PATCH 0/3 v2] net: various tilegx networking fixes
To: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revised series to have the dates on the patches correct.  Considering
I've gotten this wrong before, I promise this is the last time. :-)

This series of fixes corrects a few bugs or style issues observed
in the tilegx network driver.

David, once any potential issues with these patches are resolved,
would you prefer to take them from email, pull them from my net tree,
or have me push them as part of the tile tree?

The tree is at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git net

Chris Metcalf (3):
      net: tilegx driver bugfix (be explicit about percpu queue number)
      tilegx net driver: handle payload data not in frags
      tilegx net: use eth_hw_addr_random(), not random_ether_addr()

 drivers/net/ethernet/tile/tilegx.c |   61 ++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 27 deletions(-)

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
