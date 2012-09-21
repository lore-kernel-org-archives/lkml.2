Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab2IUSvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:51:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab2IUSvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:51:47 -0400
Date: Fri, 21 Sep 2012 14:51:44 -0400 (EDT)
Message-Id: <20120921.145144.14955032475453606.davem@davemloft.net>
To: chf.fritz@googlemail.com
Cc: rob@landley.net, kuznet@ms2.inr.ac.ru, j.weitzel@phytec.de,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, hjk@hansjkoch.de, daniel@zonque.org
Subject: Re: [PATCH v3] ipconfig: add nameserver IPs to kernel-parameter ip=
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348252279.12456.2.camel@mars>
References: <1348177730.3858.98.camel@mars>
	<20120921.133759.1667263015470766968.davem@davemloft.net>
	<1348252279.12456.2.camel@mars>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Fritz <chf.fritz@googlemail.com>
Date: Fri, 21 Sep 2012 20:31:19 +0200

> On small systems (e.g. embedded ones) IP addresses are often configured
> by bootloaders and get assigned to kernel via parameter "ip=".  If set to
> "ip=dhcp", even nameserver entries from DHCP daemons are handled. These
> entries exported in /proc/net/pnp are commonly linked by /etc/resolv.conf.
> 
> To configure nameservers for networks without DHCP, this patch adds option
> <dns0-ip> and <dns1-ip> to kernel-parameter 'ip='.
> 
> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> Tested-by: Jan Weitzel <j.weitzel@phytec.de>

Applied to net-next, thanks.
