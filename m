Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1LUXHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 18:07:04 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56536 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab1LUXHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 18:07:02 -0500
Date: Wed, 21 Dec 2011 18:05:49 -0500 (EST)
Message-Id: <20111221.180549.2295489434558987482.davem@davemloft.net>
To: peterz@infradead.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [RFC][PATCH] sparc64: remove __ARCH_WANT_UNLOCKED_CTXSW usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111221.164426.1859065550459950375.davem@davemloft.net>
References: <1323702852.13285.25.camel@twins>
	<20111221.164426.1859065550459950375.davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 15:05:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 21 Dec 2011 16:44:26 -0500 (EST)

> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon, 12 Dec 2011 16:14:12 +0100
> 
>> The only thing resting me is asking you to simply test the below patch
>> and report what happens. Hopefully things will simply work.. if not I've
>> messed up and need to go look harder :/
> 
> I'll give it a spin, and get back to you, thanks!

Ok, so far so good, I stressed out my Niagara-T3 box for a while doing gcc
bootstraps, running the testsuite, etc. and all seems well so far.

I'll keep beating on it and let you know if anything funny happens, but for
now as far as I'm concerned:

Acked-by: David S. Miller <davem@davemloft.net>
