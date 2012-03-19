Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2CSVRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:17:05 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42020
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754007Ab2CSVRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:17:03 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, kys@microsoft.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH v2,0/1] net/hyperv: Fix the code handling tx busy
Date: Mon, 19 Mar 2012 14:23:52 -0700
Message-Id: <1332192233-32305-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

note: This patch is targeting 'net-next' tree.

The change log has been updated. Thanks to Eric Dumazet 
<eric.dumazet@gmail.com> and Stephen Hemminger <shemminger@vyatta.com>
for their suggestions.

Haiyang Zhang (1):
  net/hyperv: Fix the code handling tx busy

 drivers/net/hyperv/netvsc_drv.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

-- 
1.7.4.1

