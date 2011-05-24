Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab1EXTcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:32:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39579 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab1EXTcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:32:36 -0400
Date: Tue, 24 May 2011 15:32:22 -0400 (EDT)
Message-Id: <20110524.153222.1953796640575918161.davem@davemloft.net>
To: joe@perches.com
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for May 24 (ratelimits, CONFIG_PRINTK not
 enabled)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306262988.2298.49.camel@Joe-Laptop>
References: <20110524140212.a4f19769.sfr@canb.auug.org.au>
	<20110524113328.e3d5867b.randy.dunlap@oracle.com>
	<1306262988.2298.49.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 May 2011 12:32:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 24 May 2011 11:49:48 -0700

> On Tue, 2011-05-24 at 11:33 -0700, Randy Dunlap wrote:
>> Adding <linux/ratelimit.h> to <asm-generic/bug.h> causes other problems:
> 
> Yup, that's not a good solution.

Please come up with a fix or I'll have to revert, thanks Joe.
