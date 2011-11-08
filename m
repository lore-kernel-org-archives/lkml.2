Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1KHUbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:31:23 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:53095 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1KHUbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:31:22 -0500
Subject: [PATCH] net: drivers/net/hippi/Kconfig should be sourced
From: Paul Bolle <pebolle@tiscali.nl>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 21:31:10 +0100
Message-ID: <1320784270.14409.404.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ff5a3b509e ("hippi: Move the HIPPI driver") moved the HIPPI
driver into drivers/net/hippi. It didn't source
drivers/net/hippi/Kconfig though, so it didn't make all necessary
Kconfig changes. So let drivers/net/kconfig source HIPPI's Kconfig file.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
git grep tested only. Perhaps the exact spot where
drivers/net/hippi/Kconfig gets sourced is relevant, so this needs
(build) testing by people actually familiar with the HIPPI driver. 

 drivers/net/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 583f66c..654a5e9 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -245,6 +245,8 @@ source "drivers/net/ethernet/Kconfig"
 
 source "drivers/net/fddi/Kconfig"
 
+source "drivers/net/hippi/Kconfig"
+
 config NET_SB1000
 	tristate "General Instruments Surfboard 1000"
 	depends on PNP
-- 
1.7.4.4

