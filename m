Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892Ab2FDPxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:53:53 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:38917
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754587Ab2FDPxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:53:52 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [PATCH 0/1] net/hyperv: Use wait_event on outstanding sends during device removal
Date: Mon,  4 Jun 2012 07:35:31 -0700
Message-Id: <1338820532-2345-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is targeting net-next tree (when it's available for check in).

Haiyang Zhang (1):
  net/hyperv: Use wait_event on outstanding sends during device removal

 drivers/net/hyperv/hyperv_net.h |    1 +
 drivers/net/hyperv/netvsc.c     |   12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

-- 
1.7.4.1

