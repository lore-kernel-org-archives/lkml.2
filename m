Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab2AYV6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:58:40 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53087 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2AYV6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:58:38 -0500
Date: Wed, 25 Jan 2012 16:55:48 -0500 (EST)
Message-Id: <20120125.165548.596418893115900979.davem@davemloft.net>
To: jesse@nicira.com
Cc: joseph.glanville@orionvm.com.au, steweg@ynet.sk, eric.dumazet@gmail.com,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAEP_g=9H9dV9=qtFPh4YeTNQ-t+UZGw-YqZ6hFWVNXjFy+GCZg@mail.gmail.com>
References: <CAOzFzEjE7b-Y+_vOWeBKbHDkURRcYXomSTcwB91vKHVWQxBVsg@mail.gmail.com>
	<20120124.230203.1478271172075708903.davem@davemloft.net>
	<CAEP_g=9H9dV9=qtFPh4YeTNQ-t+UZGw-YqZ6hFWVNXjFy+GCZg@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Jan 2012 13:55:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Gross <jesse@nicira.com>
Date: Tue, 24 Jan 2012 23:11:06 -0800

> On Tue, Jan 24, 2012 at 8:02 PM, David Miller <davem@davemloft.net> wrote:
>> From: Joseph Glanville <joseph.glanville@orionvm.com.au>
>> Date: Wed, 25 Jan 2012 14:48:37 +1100
>>
>>> The reason why this patch is useful is that it stands to be the only
>>> true mulitpoint L2 VPN with a kernel space forwarding plane.
>>
>> So what you're telling me is that I added this huge openvswitch
>> thing essentially for nothing?
> 
> I think it's actually the opposite - Open vSwitch can be used to
> implement this type of thing as well as for many other use cases.

Then openvswitch is exactly where you should be prototyping and
implementing support for this sort of stuff.

And only if you cannot obtain reasonable performance using openvswitch
should you be even entertaining the notion of a static implementation.

That's the whole premise behind putting openvswitch into the tree, so
that guys like you can play around in userspace without having to make
any kernel changes at all.

I am not applying these patches, the more things you say the more I am
convinced they are not appropriate.

