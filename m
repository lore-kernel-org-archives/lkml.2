Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab1D2RWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:22:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45906
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759677Ab1D2RWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:22:07 -0400
Date: Fri, 29 Apr 2011 10:21:34 -0700 (PDT)
Message-Id: <20110429.102134.193704089.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for April 29 (bpf_jit)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1304097558.2686.6.camel@edumazet-laptop>
References: <20110429131940.4f4c938f.sfr@canb.auug.org.au>
	<20110429092632.26ff1e53.randy.dunlap@oracle.com>
	<1304097558.2686.6.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 29 Apr 2011 19:19:18 +0200

> [PATCH net-next-2.6] bpf: depends on MODULES
> 
> module_alloc() and module_free() are available only if CONFIG_MODULES=y
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks.

Perhaps we can solve these things by seperating out the dependency,
via "CONFIG_MODULE_ALLOC" and making things like KPROBES and
BPF 'select' it.
