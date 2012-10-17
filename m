Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab2JQMrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:47:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab2JQMrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:47:15 -0400
Date: Wed, 17 Oct 2012 14:47:11 +0200
From: Jan Tluka <jtluka@redhat.com>
To: rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/networking/pktgen.txt: fix dst_mac and src_mac
 typo
Message-ID: <20121017124711.GA2703@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dst_mac and src_mac parameters are incorrectly written with missing
underscore - dstmac and srcmac. This typo can confuse the pktgen users.

Signed-off-by: Jan Tluka <jtluka@redhat.com>
---
 Documentation/networking/pktgen.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/pktgen.txt b/Documentation/networking/pktgen.txt
index 75e4fd7..76658c6 100644
--- a/Documentation/networking/pktgen.txt
+++ b/Documentation/networking/pktgen.txt
@@ -87,8 +87,8 @@ Examples:
  pgset "src_max 10.0.0.254"          Set the maximum source IP.
  pgset "dst6 fec0::1"     IPV6 destination address
  pgset "src6 fec0::2"     IPV6 source address
- pgset "dstmac 00:00:00:00:00:00"    sets MAC destination address
- pgset "srcmac 00:00:00:00:00:00"    sets MAC source address
+ pgset "dst_mac 00:00:00:00:00:00"    sets MAC destination address
+ pgset "src_mac 00:00:00:00:00:00"    sets MAC source address
 
  pgset "queue_map_min 0" Sets the min value of tx queue interval
  pgset "queue_map_max 7" Sets the max value of tx queue interval, for multiqueue devices
-- 
1.7.1

