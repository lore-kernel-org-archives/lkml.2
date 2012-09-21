Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2IUSeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:34:01 -0400
Received: from mail.renton.name ([90.155.165.44]:58789 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab2IUSdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:33:09 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2012 14:33:09 EDT
Date: Fri, 21 Sep 2012 22:27:04 +0400
From: Alexey Vlasov <renton@renton.name>
To: linux-kernel@vger.kernel.org
Subject: Instead of IP addresses the kernel started to show zero's
Message-ID: <20120921182703.GH16609@beaver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Here it writes LOG module (netfilter) in syslog:
====
Sep 21 22:24:04 l24 kernel: ipsec:SYN-OUTPUT-HTTP IN= OUT=eth0
SRC=0000000000000000 DST=0000000000000000 LEN=60 TOS=0x00 PREC=0x00
TTL=64 ID=9042 DF PROTO=TCP SPT=51169 DPT=80 WINDOW=14600 RES=0x00 SYN
URGP=0 UID=545369 GID=155
====

This is recent, here go zero's again.
====
cat /proc/net/xt_recent/j-brute
src=0000000000000000 ttl: 117 last_seen: 4349942400 oldest_pkt: 1
4349942400
src=0000000000000000 ttl: 119 last_seen: 4349968063 oldest_pkt: 1
4349968063
====

Can it be fixed without restarting the box?
Thanks.

# uname -a
Linux l24 3.4.6 ...

--
BRGDS. Alexey Vlasov.
