Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab2AUSGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:06:39 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:38105 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751107Ab2AUSEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:43 -0500
Message-ID: <4F1B0BEE.6000205@xenotime.net>
Date: Sat, 21 Jan 2012 11:03:10 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: [PATCH 10/14] kernel-doc: fix new warning in net/sock.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warning:

Warning(include/net/sock.h:372): No description found for parameter 'sk_cgrp_prioidx'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 include/net/sock.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx-33-rc1.orig/include/net/sock.h
+++ lnx-33-rc1/include/net/sock.h
@@ -226,6 +226,7 @@ struct cg_proto;
   *	@sk_ack_backlog: current listen backlog
   *	@sk_max_ack_backlog: listen backlog set in listen()
   *	@sk_priority: %SO_PRIORITY setting
+  *	@sk_cgrp_prioidx: socket group's priority map index
   *	@sk_type: socket type (%SOCK_STREAM, etc)
   *	@sk_protocol: which protocol this socket belongs in this network family
   *	@sk_peer_pid: &struct pid for this socket's peer
