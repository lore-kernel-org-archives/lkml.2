Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2DCWfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:35:16 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39039 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2DCWfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:35:14 -0400
Date: Tue, 03 Apr 2012 18:35:10 -0400 (EDT)
Message-Id: <20120403.183510.1401597538063331122.davem@davemloft.net>
To: kaffeemonster@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F7B7A59.2090904@googlemail.com>
References: <4F75D2A5.7060407@googlemail.com>
	<20120403.180302.342779808900865443.davem@davemloft.net>
	<4F7B7A59.2090904@googlemail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 15:35:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Seiffert <kaffeemonster@googlemail.com>
Date: Wed, 4 Apr 2012 00:31:53 +0200

> David Miller schrieb:
> [snip - my patch description]
>> 
>> I'm not applying this until a powerpc person tests it.
>> 
> 
> As Benjamin already said, Matt is having a look, so i expected nothing else.
> 
>> Also, we have an ARM JIT in the tree which probably needs to
>> be fixed similarly.
>> 
> 
> ???
> Oh, in which tree is it?
> I was working against net-next.

It's been in Linus's tree for several days now.

net-next is stale during the merge window and doesn't get updated
until the merge window closes.
