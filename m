Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1LSVWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:22:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59128 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab1LSVW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:22:28 -0500
Date: Mon, 19 Dec 2011 16:22:10 -0500 (EST)
Message-Id: <20111219.162210.1739976094495078504.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: joe@perches.com, linux-kernel@vger.kernel.org, pawel.moll@arm.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 14/15] module_param: make bool parameters really bool
 (net & drivers/net)
From: David Miller <davem@davemloft.net>
In-Reply-To: <87ehw1nm9r.fsf@rustcorp.com.au>
References: <87k45xqvfs.fsf@rustcorp.com.au>
	<20111215.231517.185391590658983405.davem@davemloft.net>
	<87ehw1nm9r.fsf@rustcorp.com.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Dec 2011 13:22:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 19 Dec 2011 16:19:52 +1030

> On Thu, 15 Dec 2011 23:15:17 -0500 (EST), David Miller <davem@davemloft.net> wrote:
>> From: Rusty Russell <rusty@rustcorp.com.au>
>> Date: Fri, 16 Dec 2011 09:44:31 +1030
>> 
>> > Dave, did you want a true/false cleanup too?
>> 
>> Please, this kind of stuff rots forever and not using bool properly
>> drives me crazy.
> 
> And here's the updated patch:

Neither of your two patches comes close to applying cleanly to net-next,
even when I try to apply it by hand there are rejects and references to
files that don't even exist in net-next any more.

Please respin them.

Thanks!
