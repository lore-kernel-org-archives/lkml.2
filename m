Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1DDCnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 22:43:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48296
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604Ab1DDCnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 22:43:41 -0400
Date: Sun, 03 Apr 2011 19:43:01 -0700 (PDT)
Message-Id: <20110403.194301.232921375.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, mirq-linux@rere.qmqm.pl
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110404112840.98dd98ec.sfr@canb.auug.org.au>
References: <20110404112840.98dd98ec.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 4 Apr 2011 11:28:40 +1000

> Hi all,
> 
> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/net/xen-netfront.c:1151: error: 'xennet_fix_features' undeclared here (not in a function)
> drivers/net/xen-netfront.c:1152: error: 'xennet_set_features' undeclared here (not in a function)
> 
> Caused by commit fb507934fd6f ("net: convert xen-netfront to hw_features").

Just pushed a fix for this to net-next-2.6, sorry about that.

