Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2BSWnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 17:43:10 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40284 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab2BSWnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 17:43:08 -0500
Date: Sun, 19 Feb 2012 17:41:00 -0500 (EST)
Message-Id: <20120219.174100.25858072359685481.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: yuvalmin@broadcom.com, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, eilong@broadcom.com,
        eric.dumazet@gmail.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120217103011.b2223e28a89839d09a4a4053@canb.auug.org.au>
References: <20120216123803.8efe3d23eee5c3a80aceef61@canb.auug.org.au>
	<1329391450.16698.27.camel@lb-tlvb-eilong.il.broadcom.com>
	<20120217103011.b2223e28a89839d09a4a4053@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Feb 2012 14:41:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 17 Feb 2012 10:30:11 +1100

> Hi,
> 
> On Thu, 16 Feb 2012 13:24:10 +0200 "Yuval Mintz" <yuvalmin@broadcom.com> wrote:
>>
>> I don't fully understand your merge - it seems to create a mash between
>> the "bnx2x: fix bnx2x_storm_stats_update() on big endian" patch in net,
>> and the "bnx2x: consistent statistics after internal driver reload"
>> patch in net-next.
> 
> That is exactly what the merge conflict resolution did.  i.e. the patch
> you supplied below is not needed in linux-next because that is
> effectively what I did.  It is the same as Dave will do when he merges
> the net tree into the net-next tree as well, I assume.

I've taken care of this.
