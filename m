Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934659Ab1IOTpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:45:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42617 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532Ab1IOTp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:45:29 -0400
Date: Thu, 15 Sep 2011 15:44:10 -0400 (EDT)
Message-Id: <20110915.154410.26623232105923613.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: mitsuo.hayasaka.hu@hitachi.com, herbert@gondor.hengli.com.au,
        shemminger@vyatta.com, kaber@trash.net, mirq-linux@rere.qmqm.pl,
        therbert@google.com, jesse@nicira.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH net-next] net: linkwatch: allow vlans to get carrier
 changes faster
From: David Miller <davem@davemloft.net>
In-Reply-To: <1314783118.2801.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <4E5A40A9.2000404@hitachi.com>
	<1314540589.3036.12.camel@edumazet-laptop>
	<1314783118.2801.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 15 Sep 2011 12:44:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 31 Aug 2011 11:31:58 +0200

> There is a time-lag of IFF_RUNNING flag consistency between vlan and
> real devices when the real devices are in problem such as link or cable
> broken.
> 
> This leads to a degradation of Availability such as a delay of failover
> in HA systems using vlan since the detection of the problem at real
> device is delayed.
> 
> We can avoid the linkwatch delay (~1 sec) for devices linked to another
> ones, since delay is already done for the realdev.
> 
> Based on a previous patch from Mitsuo Hayasaka
> 
> Reported-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
