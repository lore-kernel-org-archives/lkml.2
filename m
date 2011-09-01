Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab1IAO6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:58:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44300 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713Ab1IAO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:58:43 -0400
Date: Thu, 01 Sep 2011 10:56:29 -0400 (EDT)
Message-Id: <20110901.105629.2264978229399750709.davem@davemloft.net>
To: peterz@infradead.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: process time < thread time?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1314874459.7945.22.camel@twins>
References: <1314871884.7945.20.camel@twins>
	<alpine.LFD.2.02.1109011226160.2723@ionos>
	<1314874459.7945.22.camel@twins>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Sep 2011 07:56:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 01 Sep 2011 12:54:19 +0200

> On Thu, 2011-09-01 at 12:39 +0200, Thomas Gleixner wrote:
>> > I think we just deadlocked:
>> 
>> That's why I said untested :) 
> 
> the below seems to build boot and give consistent output.. 

Works here too.

> Reported-by: David Miller <davem@davemloft.net>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-nk5489zjtxsln3ixjonjs3h3@git.kernel.org

Tested-by: David S. Miller <davem@davemloft.net>
