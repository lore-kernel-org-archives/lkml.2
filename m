Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1GRSLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:11:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56094 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1GRSLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:11:48 -0400
Date: Mon, 18 Jul 2011 11:11:40 -0700 (PDT)
Message-Id: <20110718.111140.1966973494764275906.davem@davemloft.net>
To: joe@perches.com
Cc: jdelvare@suse.de, grundler@parisc-linux.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tulip: dmfe: Remove old log spamming pr_debugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311012332.2286.110.camel@Joe-Laptop>
References: <0a5f6c4c4c948dd5ff827bb5c5517294c9410bfc.1311000440.git.joe@perches.com>
	<20110718.104537.546991191560526229.davem@davemloft.net>
	<1311012332.2286.110.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Jul 2011 11:11:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 18 Jul 2011 11:05:32 -0700

> On Mon, 2011-07-18 at 10:45 -0700, David Miller wrote:
>> From: Joe Perches <joe@perches.com>
>> Date: Mon, 18 Jul 2011 07:50:33 -0700
>> > Commit 726b65ad444d ("tulip: Convert uses of KERN_DEBUG") enabled
>> > some old previously inactive uses of pr_debug converted by
>> > commit dde7c8ef1679 ("tulip/dmfe.c: Use dev_<level> and pr_<level>").
>> > Remove these pr_debugs.
>> > Signed-off-by: Joe Perches <joe@perches.com>
>> Applied.
> 
> I believe this should go into current if you push
> one more to Linus or maybe stable for 3.0.

I know, that's why I added it to net-2.6
