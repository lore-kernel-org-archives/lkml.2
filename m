Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab1ERRuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:50:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab1ERRuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JJGe3gaUR5hQRh5ALFx+bmiaChHoIU7ddYwcNi54Hp5uszto83iPiTgU4i3J5y7tZs
         kXKVbv4MVpFkz1n/+KxSW/JhyO1XyPkvs1NmcGAMYH8zxnauImMxE/FTtF9xwaeT5RuX
         0M1itnuUKP+vHc6t323FJtL7Yv/qSOMEqpWL0=
Date: Wed, 18 May 2011 21:49:59 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        "David S. Miller" <davem@davemloft.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] docs: describe /proc/sys/net/ipv4/ping_group_range
Message-ID: <20110518174959.GA6019@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copied the patch description from c319b4d76b9e with minor
formatting changes.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Documentation/networking/ip-sysctl.txt |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index d3d653a..3e119d9 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -717,6 +717,23 @@ icmp_errors_use_inbound_ifaddr - BOOLEAN
 
 	Default: 0
 
+ping_group_range - vector of 2 INTEGERs: min, max
+	Specify the group range allowed to create non-raw icmp sockets.
+
+	Possible applications:
+
+	1 0 (default) - nobody (not even root) may create ping sockets.
+
+	100 100 -  grant permissions to the single group to either make
+	/sbin/ping sgid'ed and owned by this group or to grant permissions
+	to the "netadmins" group.
+
+	0 4294967295 - enable it for the world.
+
+	100 4294967295 - enable it for the users, but not daemons.
+
+	Default: 1 0
+
 igmp_max_memberships - INTEGER
 	Change the maximum number of multicast groups we can subscribe to.
 	Default: 20
-- 
1.7.0.4

