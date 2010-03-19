Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab0CSPFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:05:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:40027 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0CSPFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=a33uSfqREE3XwSpsI8wt++ls0Vye2alB7zI779kyu/9mxAlgfh1f1tiVzyxEsj1V0h
         aKmW5CDvlpMfG2hYk9nasUw6JE4qffo4fxdphtpMa3X81H0kSwdAmvtRPCyq3gAxmIgC
         vpYU+ObtYuhHayEBOLbx31GOyiRjCOkWZDnqI=
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Subject: [PATCH] if_tunnel.h: add missing ams/byteorder.h include
To: davem@davemloft.net
Cc: contact@saschahlusiak.de, eric.dumazet@gmail.com,
       Fred.L.Templin@boeing.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 19 Mar 2010 17:04:57 +0200
Message-ID: <20100319150457.10959.60396.stgit@pauliusz>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: None <None>

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

