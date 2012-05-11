Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2EKCsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 22:48:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56410 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab2EKCsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 22:48:06 -0400
Date: Thu, 10 May 2012 22:43:52 -0400 (EDT)
Message-Id: <20120510.224352.2149006669429730060.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: rdunlap@xenotime.net, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, david.daney@cavium.com
Subject: Re: linux-next: Tree for May 10 (net/phy)
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAP=VYLon7XRoh9s==wGYjUPNAYaTk8QQx7FGRnaDR97v+O-zXA@mail.gmail.com>
References: <20120510192635.c6f3a55196bbf65f13956e44@canb.auug.org.au>
	<4FAC35E2.4060900@xenotime.net>
	<CAP=VYLon7XRoh9s==wGYjUPNAYaTk8QQx7FGRnaDR97v+O-zXA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 19:43:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 10 May 2012 22:36:55 -0400

> On Thu, May 10, 2012 at 5:40 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On 05/10/2012 02:26 AM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120508:
>>
>>
>>
>> ERROR: "of_mdio_find_bus" [drivers/net/phy/mdio-mux.ko] undefined!
> 
> Not just randconfig, but also powerpc allmodconfig:
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/6291463/
> 
> Adding ppc ML to cc.

Adding the guilty party to the CC:.  This really stinks, especially
after I did give the patch submitter a hard time about getting the
dependencies right. :-/
