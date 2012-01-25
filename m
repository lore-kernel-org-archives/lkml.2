Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2AYEC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 23:02:56 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44821 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2AYECy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 23:02:54 -0500
Date: Tue, 24 Jan 2012 23:00:42 -0500 (EST)
Message-Id: <20120124.230042.1180973944381398704.davem@davemloft.net>
To: Ian.Campbell@citrix.com
Cc: konrad.wilk@oracle.com, tina.yang@oracle.com, zhenzhong.duan@oracle.com,
        xen-devel@lists.xensource.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gurudas.pai@oracle.com, jeremy@goop.org
Subject: Re: [PATCH] add netconsole support for xen-netfront
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327395480.17019.1.camel@dagon.hellion.org.uk>
References: <4F173467.90106@oracle.com>
	<20120123182443.GA22963@phenom.dumpdata.com>
	<1327395480.17019.1.camel@dagon.hellion.org.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 Jan 2012 20:00:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Tue, 24 Jan 2012 08:58:00 +0000

> On Mon, 2012-01-23 at 18:24 +0000, Konrad Rzeszutek Wilk wrote:
> 
>> From 1c265b7946f222ab6a5aac5245a0ab84618772c8 Mon Sep 17 00:00:00 2001
>> From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> Date: Thu, 12 Jan 2012 10:18:29 +0800
>> Subject: [PATCH] xen/netfront: add netconsole support.
>> 
>> add polling interface to xen-netfront device to support netconsole
>> 
>> This patch also alters the spin_lock usage to use irqsave variant.
>> Documentation/networking/netdevices.txt states that start_xmit
>> can be called with interrupts disabled by netconsole and therefore using
>> the irqsave/restore locking in this function is looks correct.
>> 
>> Signed-off-by: Tina.Yang <tina.yang@oracle.com>
>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> Signed-off-by: Zhenzhong.Duan <zhenzhong.duan@oracle.com>
>> Tested-by: gurudas.pai <gurudas.pai@oracle.com>
>> [v1: Copy-n-pasted Ian Campbell comments]
>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

Applied.
