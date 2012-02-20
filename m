Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2BTQHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:07:11 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:43142 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2BTQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:07:07 -0500
From: Javier Martinez Canillas <javier@collabora.co.uk>
To: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alban Crequy <alban.crequy@collabora.co.uk>,
        Bart Cerneels <bart.cerneels@collabora.co.uk>,
        Rodrigo Moya <rodrigo.moya@collabora.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] af_unix: Add constant for unix socket options level
Date: Mon, 20 Feb 2012 16:57:27 +0100
Message-Id: <1329753455-1106-3-git-send-email-javier@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1329753455-1106-1-git-send-email-javier@collabora.co.uk>
References: <1329753455-1106-1-git-send-email-javier@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Crequy <alban.crequy@collabora.co.uk>

Assign the next free socket options level to be used by the unix
protocol and address family.

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
Reviewed-by: Ian Molton <ian.molton@collabora.co.uk>
---
 include/linux/socket.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index d0e77f6..a6b8f35 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -312,6 +312,7 @@ struct ucred {
 #define SOL_IUCV	277
 #define SOL_CAIF	278
 #define SOL_ALG		279
+#define SOL_UNIX	280
 
 /* IPX options */
 #define IPX_TYPE	1
-- 
1.7.7.6

