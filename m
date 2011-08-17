Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1HQDHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 23:07:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42355 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1HQDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 23:07:31 -0400
Date: Tue, 16 Aug 2011 20:05:28 -0700 (PDT)
Message-Id: <20110816.200528.63647861483543536.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: boot test failure (net tree)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110817112110.ec81ef078204bf4a02049a66@canb.auug.org.au>
References: <20110817105002.efebf85d08460ad99b14be8e@canb.auug.org.au>
	<20110816.175657.1688139393736610845.davem@davemloft.net>
	<20110817112110.ec81ef078204bf4a02049a66@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 16 Aug 2011 20:05:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 17 Aug 2011 11:21:10 +1000

> On Tue, 16 Aug 2011 17:56:57 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
>>
>> This happens on other occaisions, I see new group guards all
>> the time when I resync my net and net-next trees with Linus.
> 
> "All the time"?  really?

I can't think of too many days during the merge window where this
doesn't happen, quite frankly.
