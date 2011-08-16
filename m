Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1HPHT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:19:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33313 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1HPHT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:19:27 -0400
Date: Tue, 16 Aug 2011 00:17:11 -0700 (PDT)
Message-Id: <20110816.001711.169179303753669881.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110816165744.5c069b0c9f2e329e48ecd7d0@canb.auug.org.au>
References: <20110816152815.911f15937efa2ebf58a2795d@canb.auug.org.au>
	<20110815.231116.1728582609642497613.davem@davemloft.net>
	<20110816165744.5c069b0c9f2e329e48ecd7d0@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 16 Aug 2011 00:17:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 16 Aug 2011 16:57:44 +1000

> Hi Dave,
> 
> On Mon, 15 Aug 2011 23:11:16 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
>>
>> Please test this patch:
>> 
>> --------------------
>> net: Fix sungem_phy sharing.
> 
> This fixes my allyesconfig build (and doesn't break any of the others :-)).
> 
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks a lot for testing.
