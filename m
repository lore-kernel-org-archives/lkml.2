Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2ICBoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 21:44:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39845 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755477Ab2ICBoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 21:44:15 -0400
X-Sasl-enc: /pBRbcH0+b2NJZMtc1CYqVrVUlp+q8MmExf/jAg8D0kf 1346636654
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Cheneau <tony.cheneau@amnesiak.org>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v7 0/1] Driver for Microchip MRF24J40
Date: Sun,  2 Sep 2012 21:44:12 -0400
Message-Id: <1346636653-28903-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1346300194-3286-1-git-send-email-alan@signal11.us>
References: <1346300194-3286-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for the Microchip MRF24J40 802.15.4 transceiver.

This is the same as v6 except that it now puts the driver in
drivers/net/ieee802154 instead of drivers/ieee802154, since
drivers/ieee802154 was recently moved to drivers/net/ieee802154 in
0739d643b8dda866d1011bcf

Full history and discussion can be found on the archives of the linux-zigbee
mailing list:

http://www.mail-archive.com/linux-zigbee-devel@lists.sourceforge.net/msg01014.html

Alan Ott (1):
  ieee802154: MRF24J40 driver

 drivers/net/ieee802154/Kconfig    |  11 +
 drivers/net/ieee802154/Makefile   |   1 +
 drivers/net/ieee802154/mrf24j40.c | 767 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 779 insertions(+)
 create mode 100644 drivers/net/ieee802154/mrf24j40.c

-- 
1.7.11.2

