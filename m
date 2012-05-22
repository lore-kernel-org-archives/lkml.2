Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab2EVTHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:07:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49954 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2EVTHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:07:32 -0400
Date: Tue, 22 May 2012 15:05:25 -0400 (EDT)
Message-Id: <20120522.150525.1965961563976193101.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120522182010.f93a38e575ed34e88de5b787@canb.auug.org.au>
References: <20120522182010.f93a38e575ed34e88de5b787@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 May 2012 12:05:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 22 May 2012 18:20:10 +1000

> After merging the final tree, today's linux-next build (sparc32 defconfig)
> failed like this:
> 
> arch/sparc/kernel/time_32.c: In function 'timer_interrupt':
> arch/sparc/kernel/time_32.c:105:3: error: invalid use of undefined type 'struct clock_event_device'
 ...
> I have no idea what caused this, I did not get this yesterday.  I have
> left this build broken for today.

It builds cleanly in Linus's tree, and I have no local changes in sparc-next.
