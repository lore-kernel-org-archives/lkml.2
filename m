Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2FSHHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:07:44 -0400
Received: from serv04.lahn.de ([213.239.197.57]:46451 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab2FSHHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:07:42 -0400
X-Greylist: delayed 952 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2012 03:07:42 EDT
Date: Tue, 19 Jun 2012 08:51:37 +0200
From: Michael Leun <lkml20120218@newton.leun.net>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ath9k_htc: Every 2nd packet 1000ms delayed in recent kernels
Message-ID: <20120619085137.337838c0@xenia.leun.net>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ne-wlan1@elektra:/home/ml4> ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
64 bytes from 192.168.2.1: icmp_seq=1 ttl=64 time=2010 ms
64 bytes from 192.168.2.1: icmp_seq=2 ttl=64 time=1011 ms
64 bytes from 192.168.2.1: icmp_seq=3 ttl=64 time=11.5 ms
64 bytes from 192.168.2.1: icmp_seq=4 ttl=64 time=1.12 ms
64 bytes from 192.168.2.1: icmp_seq=5 ttl=64 time=1002 ms
64 bytes from 192.168.2.1: icmp_seq=6 ttl=64 time=3.83 ms
64 bytes from 192.168.2.1: icmp_seq=7 ttl=64 time=1003 ms
64 bytes from 192.168.2.1: icmp_seq=8 ttl=64 time=4.10 ms
64 bytes from 192.168.2.1: icmp_seq=9 ttl=64 time=1003 ms
64 bytes from 192.168.2.1: icmp_seq=10 ttl=64 time=3.95 ms
64 bytes from 192.168.2.1: icmp_seq=11 ttl=64 time=1003 ms
64 bytes from 192.168.2.1: icmp_seq=12 ttl=64 time=3.78 ms


Please note the additional delay of ~1000ms every 2nd packet. This is
Kernel 3.4.3, have seen it in 3.4.2 also. Does NOT happen in 3.3.1.

Is this Issue already known? If so, I can save the work bisecting...

Happens with two different ath9k_htc cards:

Bus 002 Device 012: ID 0846:9018 NetGear, Inc. WNDA3200 802.11abgn Wireless Adapter [Atheros AR7010+AR9280]
Bus 002 Device 004: ID 0cf3:7015 Atheros Communications, Inc. TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]

Does NOT happen with an atk9k (mini pci express) card.

-- 
MfG,

Michael Leun

