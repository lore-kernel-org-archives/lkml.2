Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1GOQV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:21:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51458 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1GOQVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:21:25 -0400
Date: Fri, 15 Jul 2011 09:21:11 -0700 (PDT)
Message-Id: <20110715.092111.70925645362970092.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: a.p.zijlstra@chello.nl, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mm, sparc64: Implement gup_fast()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110713153348.b68b4196.akpm@linux-foundation.org>
References: <20110712122608.938583937@chello.nl>
	<1310474531.14978.29.camel@twins>
	<20110713153348.b68b4196.akpm@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 15 Jul 2011 09:21:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 13 Jul 2011 15:33:48 -0700

> On Tue, 12 Jul 2011 14:42:11 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>> On Tue, 2011-07-12 at 14:26 +0200, Peter Zijlstra wrote:
>> > With the recent mmu_gather changes that included generic RCU freeing of
>> > page-tables, it is now quite straight forward to implement gup_fast() on
>> > sparc64.
>> > 
>> > Andrew, please consider merging these patches.
>> 
>> Gah, quilt-mail ate all the From: headers again.. all 4 patches are in
>> fact written by davem. Do you want a resend?
> 
> I have an editor ;)
> 
> I expect these would get more (ie: non-zero) testing if they were
> merged via Dave's tree?

It's actually easier if you merge these in for me Andrew, thanks!
