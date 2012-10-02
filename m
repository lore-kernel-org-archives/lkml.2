Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab2JBSgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:36:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49780 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2JBSga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:36:30 -0400
Date: Tue, 02 Oct 2012 14:36:27 -0400 (EDT)
Message-Id: <20121002.143627.1565408497543880722.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        shemminger@vyatta.com
Subject: Re: linux-next: Tree for Oct 2 (vxlan.c)
From: David Miller <davem@davemloft.net>
In-Reply-To: <506B3317.5090006@xenotime.net>
References: <20121002163229.d377074dc8f6c029428faeaa@canb.auug.org.au>
	<506B3317.5090006@xenotime.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Tue, 02 Oct 2012 11:31:51 -0700

> on x86_64:
> 
> drivers/net/vxlan.c: In function 'vxlan_xmit':
> drivers/net/vxlan.c:725:2: error: implicit declaration of function 'ip_select_ident'
> 
> That function is only defined when CONFIG_INET is enabled,
> but it is disabled in this config.

This definitely depends upon INET, I'll add the Kconfig change
to net-next, thanks.
