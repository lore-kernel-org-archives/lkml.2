Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1GEEmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 00:42:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35986 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1GEEl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 00:41:58 -0400
Date: Mon, 04 Jul 2011 21:38:08 -0700 (PDT)
Message-Id: <20110704.213808.1604572852149444948.davem@davemloft.net>
To: meissner@novell.com
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, meissner@suse.de, max@suse.de
Subject: Re: [PATCH] net: bind() fix error return on wrong address family
From: David Miller <davem@davemloft.net>
In-Reply-To: <1309779029-15403-1-git-send-email-meissner@novell.com>
References: <1309779029-15403-1-git-send-email-meissner@novell.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 04 Jul 2011 21:38:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Meissner <meissner@novell.com>
Date: Mon,  4 Jul 2011 13:30:29 +0200

> Reinhard Max also pointed out that the error should EAFNOSUPPORT according
> to POSIX.
> 
> The Linux manpages have it as EINVAL, some other OSes (Minix, HPUX, perhaps BSD) use
> EAFNOSUPPORT. Windows uses WSAEFAULT according to MSDN.
> 
> Other protocols error values in their af bind() methods in current mainline git as far
> as a brief look shows:
> 	EAFNOSUPPORT: atm, appletalk, l2tp, llc, phonet, rxrpc
> 	EINVAL: ax25, bluetooth, decnet, econet, ieee802154, iucv, netlink, netrom, packet, rds, rose, unix, x25, 
> 	No check?: can/raw, ipv6/raw, irda, l2tp/l2tp_ip
> 
> Signed-off-by: Marcus Meissner <meissner@suse.de>
> Cc: Reinhard Max <max@suse.de>

Applied to net-2.6, thanks.
