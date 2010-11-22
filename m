Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab0KVSjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:39:25 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:38589 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab0KVSjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:39:24 -0500
From: Alban Crequy <alban.crequy@collabora.co.uk>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Ian Molton <ian.molton@collabora.co.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alban Crequy <alban.crequy@collabora.co.uk>
Subject: [PATCH 1/9] AF_UNIX: Add constant for Unix socket options level
Date: Mon, 22 Nov 2010 18:36:14 +0000
Message-Id: <1290450982-17480-1-git-send-email-alban.crequy@collabora.co.uk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101122183447.124afce5@chocolatine.cbg.collabora.co.uk>
References: <20101122183447.124afce5@chocolatine.cbg.collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign the next free socket options level to be used by the Unix
protocol and address family.

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
---
 include/linux/socket.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 86b652f..7c5a4da 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -307,6 +307,7 @@ struct ucred {
 #define SOL_RDS		276
 #define SOL_IUCV	277
 #define SOL_CAIF	278
+#define SOL_UNIX	279
 
 /* IPX options */
 #define IPX_TYPE	1
-- 
1.7.1

