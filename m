Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675Ab0EDUDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:03:37 -0400
Received: from mx4.wp.pl ([212.77.101.8]:32882 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933658Ab0EDUDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:03:35 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2010 16:03:34 EDT
Date: Tue, 4 May 2010 21:59:39 +0200
From: Marek Szuba <scriptkiddie@wp.pl>
To: linux-kernel@vger.kernel.org
Subject: Cannot create NETLINK_NFLOG sockets
Message-ID: <20100504215939.251605b3@asuka.dyndns.cern.ch>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [oVPk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,

I have just stumbled upon a rather strange problem... It seems whenever
a program on my system tries to create a netlink socket of the
NETLINK_NFLOG type, the call fails with a "protocol not supported"
error. Having first encountered this trying to get ulogd running for
the iptables NFLOG target, I have managed to reproduce it with a short C
program which does nothing but try to open such a socket. Netlink in
general works fine.

My kernel is Linux-2.6.33, with the following netlink-related options
set:
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m

The problem appears regardless of whether these modules are loaded or
not.

Could you help me debug the problem? If you need any more information,
please let me know. PS. I'm not on LKML at present so please add me
directly to any replies.

All the best,
-- 
MS
