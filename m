Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2C0XNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 19:13:19 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53983
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755717Ab2C0XNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 19:13:17 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [PATCH v3,0/1] net/hyperv: Add flow control based on hi/low watermark
Date: Tue, 27 Mar 2012 16:20:44 -0700
Message-Id: <1332890445-12562-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is targeting 'net-next' tree (when re-opened).


Haiyang Zhang (1):
  net/hyperv: Add flow control based on hi/low watermark

 drivers/hv/ring_buffer.c        |   31 -----------------------------
 drivers/net/hyperv/netvsc.c     |   41 +++++++++++++++++++++++++++++++++++---
 drivers/net/hyperv/netvsc_drv.c |    6 ++++-
 include/linux/hyperv.h          |   27 +++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 36 deletions(-)

-- 
1.7.4.1

