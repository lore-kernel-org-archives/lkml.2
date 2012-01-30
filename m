Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2A3SLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:11:09 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40391 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2A3SLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:11:07 -0500
Date: Mon, 30 Jan 2012 13:11:04 -0500 (EST)
Message-Id: <20120130.131104.1782962680660646529.davem@davemloft.net>
To: dvlasenk@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Deinline __nlmsg_put and genlmsg_put. -7k code on i386
 defconfig
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F2597D3.6050606@redhat.com>
References: <4F2597D3.6050606@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Jan 2012 10:11:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <dvlasenk@redhat.com>
Date: Sun, 29 Jan 2012 20:02:43 +0100

> This change also removes commented-out copy of __nlmsg_put
> which was last touched in 2005 with "Enable once all users
> have been converted" comment on top.
> 
>    text	   data	    bss	    dec	    hex	filename
> 8453183	 533115	1810804	10797102 a4c02e	vmlinux.o.before
> 8446103	 533115	1810804	10790022 a4a486	vmlinux.o
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

This doesn't apply to net-next, it appears it was corrupted by your
email client:

> -static __inline__ struct nlmsghdr *
> -__nlmsg_put(struct sk_buff *skb, u32 pid, u32 seq, int type, int len,
> -int flags)

It appears to have chopped up a long line here, for example.
