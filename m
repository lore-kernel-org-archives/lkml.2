Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0JPS6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 14:58:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35291
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612Ab0JPS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 14:58:33 -0400
Date: Sat, 16 Oct 2010 11:58:55 -0700 (PDT)
Message-Id: <20101016.115855.179956240.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org, jgarzik@pobox.com
Subject: Re: [PATCH -next] net: move MII outside of NET_ETHERNET, fix
 kconfig warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101013181859.fc3a96fd.randy.dunlap@oracle.com>
References: <20101013181859.fc3a96fd.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 13 Oct 2010 18:18:59 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> We have USB, PCMCIA, and gigabit ethernet drivers that select
> MII even though NET_ETHERNET is not enabled, so make MII not
> be dependent on NET_ETHERNET.  It is still dependent on NET
> and NETDEVICES.
> 
> Fixes kconfig unmet dependency warning (shortened, was very long string):
 ...
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: Jeff Garzik <jgarzik@pobox.com> [2006-NOV-30]

Applied, and I added your infiniband patch too.

Thanks Randy.
