Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0GVEJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 00:09:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37201
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890Ab0GVEJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 00:09:30 -0400
Date: Wed, 21 Jul 2010 21:09:47 -0700 (PDT)
Message-Id: <20100721.210947.00037033.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100722121157.344c8462.sfr@canb.auug.org.au>
References: <20100722121157.344c8462.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 22 Jul 2010 12:11:57 +1000

> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> drivers/vhost/net.c: In function 'vhost_net_set_backend':
> drivers/vhost/net.c:536: warning: label 'done' defined but not used
> 
> Introduced by commit 11fe883936980fe242869d671092a466cf1db3e3 ("Merge
> branch 'master' of
> master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6") which
> kept the unneeded label.  Sorry if I misguided you.

I've fixed this, thanks Stephen.  Don't worry, not your fault :)
