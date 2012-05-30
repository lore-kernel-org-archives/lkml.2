Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2E3Vv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:51:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42178 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab2E3Vv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:51:28 -0400
Date: Wed, 30 May 2012 17:50:20 -0400 (EDT)
Message-Id: <20120530.175020.1714406888633137662.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8021q/vlan: process NETDEV_GOING_DOWN
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1205302344200.8234@debianer>
References: <alpine.DEB.2.02.1205302055140.1587@debianer>
	<20120530.162751.80640634568619332.davem@davemloft.net>
	<alpine.DEB.2.02.1205302344200.8234@debianer>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 30 May 2012 14:50:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Wed, 30 May 2012 23:47:32 +0200 (CEST)

> 
> On Wed, 30 May 2012, David Miller wrote:
>> From: Eldad Zack <eldad@fogrefinery.com>
>> Date: Wed, 30 May 2012 21:11:02 +0200 (CEST)
>> 
>> > In case a certain protocol needs to send a "dying gasp" packet, when you 
>> > administrativly shutdown the port (which is also what happens when you 
>> > restart the machine).
>> 
>> No in tree users have this requirement, therefore your patch is
>> inappropriate.
> 
> You are right in that, that no in tree users have this requirement 
> (yet), but in the same time it doesn't harm any existing code.
> 
> Don't you agree that it's the right order to do the notifications?

It's not an issue that matters upstream, so I simply do not care.

When you, or someone else, submits code that needs this facility
then we can talk about it.

Otherwise it's just a waste of our time.
