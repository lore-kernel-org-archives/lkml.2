Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab0CSPJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:09:31 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61223 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab0CSPJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=DCM6fINyP6EH/gZuDr22fjlc2zW3Rrd9P2hAO20T3SfyyJpjA1ZZoP1i1ohp7HF6NP
         DmbE7R1MPE2Q2PA/IJhY4aMsP0bUO4i6+huSPiC/ft4AUNQeXjslnx45n/IoKGs9f/iH
         EMOnApxbOJEi511bn3f67p8VGMNL82lsinNTs=
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Subject: [PATCH v2] if_tunnel.h: add missing ams/byteorder.h include
To: davem@davemloft.net
Cc: contact@saschahlusiak.de, eric.dumazet@gmail.com,
       Fred.L.Templin@boeing.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 19 Mar 2010 17:09:26 +0200
Message-ID: <20100319150926.11037.39136.stgit@pauliusz>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling userspace application which includes
if_tunnel.h and uses GRE_* defines you will get undefined
reference to __cpu_to_be16.

Fix this by adding missing #include <asm/byteorder.h>

Cc: stable@kernel.org
Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
---

 include/linux/if_tunnel.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/if_tunnel.h b/include/linux/if_tunnel.h
index 1822d63..16b92d0 100644
--- a/include/linux/if_tunnel.h
+++ b/include/linux/if_tunnel.h
@@ -2,6 +2,7 @@
 #define _IF_TUNNEL_H_
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 
 #ifdef __KERNEL__
 #include <linux/ip.h>

