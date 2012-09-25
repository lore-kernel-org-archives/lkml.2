Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab2IYK03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:26:29 -0400
Received: from mail.renton.name ([90.155.165.44]:51538 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab2IYK02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:26:28 -0400
Date: Tue, 25 Sep 2012 14:26:07 +0400
From: Alexey Vlasov <renton@renton.name>
To: linux-kernel@vger.kernel.org
Subject: Instead of IP addresses the kernel started to show zero's
Message-ID: <20120925102607.GC23296@beaver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Here it writes LOG target from syslog:

Sep 25 03:23:49 l24 kernel: ip:SYN-OUTPUT-HTTP IN= OUT=eth0
SRC=0000000000000000 DST=0000000000000000 LEN=60 TOS=0x00 PREC=0x00
TTL=64 ID=22467 DF PROTO=TCP SPT=52829 DPT=80 WINDOW=14600 RES=0x00 SYN
URGP=0 UID=564373 GID=155

This is recent, here go zero's again:
# cat /proc/net/xt_recent/ssh-brute
...
src=0000000000000000 ttl: 122 last_seen: 4371027622 oldest_pkt: 1
4371027622

Can it be fixed without restarting the box?
Thanks!

Kernel 3.4.6.

-- 
BRGDS. Alexey Vlasov.
