Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967103Ab2EPAMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:12:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42366 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966737Ab2EPAML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:12:11 -0400
From: Joe Perches <joe@perches.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net/ipv4 and net/ipv6 logging cleanups
Date: Tue, 15 May 2012 17:11:52 -0700
Message-Id: <cover.1337126962.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (2):
  net: ipv6: Standardize prefixes for message logging
  net: ipv4 and ipv6: Convert printk(KERN_DEBUG to pr_debug

 net/ipv4/ah4.c                |    4 +-
 net/ipv4/arp.c                |    9 +++--
 net/ipv4/devinet.c            |    5 +--
 net/ipv4/inet_timewait_sock.c |    4 +-
 net/ipv4/route.c              |    9 ++---
 net/ipv4/tcp_input.c          |   48 ++++++++++++++--------------
 net/ipv4/tcp_output.c         |    4 ++-
 net/ipv6/addrconf.c           |   68 ++++++++++++++++++-----------------------
 net/ipv6/addrlabel.c          |    2 +-
 net/ipv6/af_inet6.c           |   14 +++-----
 net/ipv6/ah6.c                |   16 +++++----
 net/ipv6/esp6.c               |   14 +++++---
 net/ipv6/icmp.c               |    8 ++--
 net/ipv6/ip6_fib.c            |   25 ++++++++-------
 net/ipv6/ip6_tunnel.c         |   23 ++++++-------
 net/ipv6/ip6mr.c              |    2 +-
 net/ipv6/ipcomp6.c            |   15 +++++---
 net/ipv6/mcast.c              |    3 +-
 net/ipv6/mip6.c               |   30 +++++++++---------
 net/ipv6/ndisc.c              |   22 +++++--------
 net/ipv6/route.c              |    8 +++--
 net/ipv6/sit.c                |    6 ++-
 net/ipv6/tunnel6.c            |   10 +++--
 23 files changed, 173 insertions(+), 176 deletions(-)

-- 
1.7.8.111.gad25c.dirty
