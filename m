Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1EPTjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:39:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60423 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1EPTjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:39:22 -0400
Date: Mon, 16 May 2011 15:38:44 -0400 (EDT)
Message-Id: <20110516.153844.1072050131335197211.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, segoon@openwall.com
Subject: Re: linux-next: Tree for May 16 (net/ipv4/ping)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110516123534.5d3a51b9.randy.dunlap@oracle.com>
References: <20110516151019.be338f1c.sfr@canb.auug.org.au>
	<20110516123534.5d3a51b9.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 16 May 2011 12:38:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 16 May 2011 12:35:34 -0700

> On Mon, 16 May 2011 15:10:19 +1000 Stephen Rothwell wrote:
> 
>> Hi all,
>> 
>> Changes since 20110513:
> 
> 
> when CONFIG_PROC_SYSCTL is not enabled:
> 
> ping.c:(.text+0x52af3): undefined reference to `inet_get_ping_group_range_net'

Vasiliy, please fix this.
