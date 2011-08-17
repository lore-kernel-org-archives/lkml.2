Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1HQA7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:59:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53911 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1HQA7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:59:02 -0400
Date: Tue, 16 Aug 2011 17:56:57 -0700 (PDT)
Message-Id: <20110816.175657.1688139393736610845.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: boot test failure (net tree)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110817105002.efebf85d08460ad99b14be8e@canb.auug.org.au>
References: <20110817100146.3b557cf815a5a2ae09bc09a7@canb.auug.org.au>
	<20110816.171525.639251389938336183.davem@davemloft.net>
	<20110817105002.efebf85d08460ad99b14be8e@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 16 Aug 2011 17:56:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 17 Aug 2011 10:50:02 +1000

> Which is a bit of a pain for automated systems.  Ours does (essentially):
> 
> yes '' | make oldconfig
> 
> We really don't want to select every new config item that comes along.

If you're indeed piping "yes" output to "make oldconfig" on an
existing config, it would select the new guards for you.

This happens on other occaisions, I see new group guards all
the time when I resync my net and net-next trees with Linus.
