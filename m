Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab2CZWL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:11:28 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51842
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757240Ab2CZWL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:11:27 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [PATCH 0/1] net/hyperv: Add flow control based on hi/low watermark
Date: Mon, 26 Mar 2012 15:18:23 -0700
Message-Id: <1332800304-5060-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is targeting 'net-next' tree.

Thanks to Stephen Hemminger <shemminger@vyatta.com> for his suggestions.


Haiyang Zhang (1):
  net/hyperv: Add flow control based on hi/low watermark

 drivers/hv/ring_buffer.c        |   15 +++++++++++++++
 drivers/net/hyperv/hyperv_net.h |    3 +++
 drivers/net/hyperv/netvsc.c     |   23 +++++++++++++++++++----
 drivers/net/hyperv/netvsc_drv.c |   16 +++++++++++++++-
 include/linux/hyperv.h          |    3 +++
 5 files changed, 55 insertions(+), 5 deletions(-)

-- 
1.7.4.1

