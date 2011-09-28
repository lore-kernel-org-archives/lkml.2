Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1I1RPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:15:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:32857 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1I1RPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:15:02 -0400
Date: Wed, 28 Sep 2011 13:12:42 -0400 (EDT)
Message-Id: <20110928.131242.1368255500458954764.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@suse.de, stable@kernel.org, mst@redhat.com, akong@redhat.com
Subject: Re: Possible NULL dereference caused by -stable commit
 ef81bb40bf15f350fe865f31fa42f1082772a576
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317211749.2941.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <4E82FC4E.5010101@redhat.com>
	<1317211749.2941.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Sep 2011 10:12:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 28 Sep 2011 14:09:09 +0200

> All we need here is not the route but inet_peer, so that inet_getid()
> can be called on it.

It's not exactly that simple, you have to parse all hop-by-hop options
to get the correct "destination" address.
