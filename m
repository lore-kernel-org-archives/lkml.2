Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0LJETB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 23:19:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35734
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab0LJETA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 23:19:00 -0500
Date: Thu, 09 Dec 2010 20:19:26 -0800 (PST)
Message-Id: <20101209.201926.104055585.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        torvalds@osdl.org
Subject: Re: [PATCH 0/2] New jhash function
From: David Miller <davem@davemloft.net>
In-Reply-To: <201012090753.46050.rusty@rustcorp.com.au>
References: <1291379941-31565-1-git-send-email-kadlec@blackhole.kfki.hu>
	<20101208.090954.115924303.davem@davemloft.net>
	<201012090753.46050.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 9 Dec 2010 07:53:45 +1030

> On Thu, 9 Dec 2010 03:39:54 am David Miller wrote:
>> From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>> Date: Fri,  3 Dec 2010 13:38:59 +0100
>> 
>> > The current jhash.h implements the lookup2() hash function by Bob Jenkins. 
>> > However, lookup2() is outdated as Bob wrote a new hash function called 
>> > lookup3(). There is a longer comparison of those two and other hash
>> > functions at http://burtleburtle.net/bob/hash/doobs.html.
>> > 
>> > Please consider applying the following patches.
>> 
>> Patch #1 is already in the net-next-2.6 tree, and as long as there are
>> no major objections to the general crowd (including Rusty et al.) I am
>> happy to put patch #2 into my tree as well.
>> 
>> Rusty, does the current version of patch #2 look good to you?
> 
> Yes, 2/2 good.  Thanks Jozsef!
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Applied, thanks everyone.
