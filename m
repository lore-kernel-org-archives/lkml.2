Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab0CWBE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 21:04:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53037
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756228Ab0CWBEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:04:55 -0400
Date: Mon, 22 Mar 2010 18:05:18 -0700 (PDT)
Message-Id: <20100322.180518.24600284.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       therbert@google.com
Subject: Re: linux-next: Tree for March 22 (net-sysfs.c)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1269290922.3043.9.camel@edumazet-laptop>
References: <4BA78D3D.9090007@oracle.com>
	<20100322.102206.148561893.davem@davemloft.net>
	<1269290922.3043.9.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 22 Mar 2010 21:48:42 +0100

> [PATCH net-next-2.6] net: RPS depends on CONFIG_SYSFS
> 
> Randy Dunlap found net/core/net-sysfs.c could not compile if
> CONFIG_SYSFS=n
> 
> Defines CONFIG_RPS in net/Kconfig to let user disable RPS if wanted.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

This is interesting but I'd like to be able to use some
of the RPS infrastructure unconditionally so I'm not ready
to apply something like this yet.

So I'll add Tom's fix for now, thanks Eric!
