Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1FTFi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:38:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58668 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1FTFi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:38:27 -0400
Date: Sun, 19 Jun 2011 22:36:15 -0700 (PDT)
Message-Id: <20110619.223615.454360261348822405.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, greg@kroah.com, adobriyan@gmail.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110620145807.9c202509.sfr@canb.auug.org.au>
References: <20110609145657.96fae0d0.sfr@canb.auug.org.au>
	<20110615085617.949d418f.sfr@canb.auug.org.au>
	<20110620145807.9c202509.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Jun 2011 22:36:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 20 Jun 2011 14:58:07 +1000

> On Wed, 15 Jun 2011 08:56:17 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> On Thu, 9 Jun 2011 14:56:57 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> I think that this patch would probably apply to just the net-next tree
>> anyway.
> 
> Ping.

Sorry, this slipped through the cracks, I'll take care of this right now.
