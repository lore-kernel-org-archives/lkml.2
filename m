Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1LJSMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 13:12:37 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51747 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1LJSMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 13:12:35 -0500
Date: Sat, 10 Dec 2011 13:12:28 -0500 (EST)
Message-Id: <20111210.131228.456749220758392202.davem@davemloft.net>
To: artisdom@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipip, sit: copy parms.name after register_netdevice
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111210142920.GA3988@gmail.com>
References: <20111207.235602.1465915988125994516.davem@davemloft.net>
	<20111208104619.GA20150@ted-OptiPlex-380>
	<20111210142920.GA3988@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 10 Dec 2011 10:12:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ted Feng <artisdom@gmail.com>
Date: Sat, 10 Dec 2011 22:29:24 +0800

> On Thu, Dec 08, 2011 at 06:46:21PM +0800, Ted Feng wrote:
>> From: Ted Feng <artisdom@gmail.com>
>> 
>> Same fix as 731abb9cb2 for ipip and sit tunnel.
>> Commit 1c5cae815d removed an explicit call to dev_alloc_name in
>> ipip_tunnel_locate and ipip6_tunnel_locate, because register_netdevice
>> will now create a valid name, however the tunnel keeps a copy of the
>> name in the private parms structure. Fix this by copying the name back
>> after register_netdevice has successfully returned.
>> 
> Just a reminder. The previous resubmited patch got no response.

So?  It's queued up in patchwork:

http://patchwork.ozlabs.org/project/netdev/list/

and therefore will get looked at when someone finds the time.
