Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab0EGC1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:27:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49855 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0EGC1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:27:53 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: davem@davemloft.net, Sascha Hauer <s.hauer@pengutronix.de>,
       Greg Ungerer <gerg@uclinux.org>,
       Amit Kucheria <amit.kucheria@canonical.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] net-next/fec: bug fixing after introduced phylib supporting
Date: Fri,  7 May 2010 10:27:17 +0800
Message-Id: <1273199239-11057-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After introduced phylib supporting, we found some critical issues in Ubuntu on
Freescale iMX51. Following 2 patches fix those bugs which was recorded in our
Launchpad bug tracker.

Bryan Wu (2):
  netdev/fec: fix performance impact from mdio poll operation
  netdev/fec: fix ifconfig eth0 down hang issue

 drivers/net/fec.c |   73 +++++++++++++++++++++++++++--------------------------
 1 files changed, 37 insertions(+), 36 deletions(-)

