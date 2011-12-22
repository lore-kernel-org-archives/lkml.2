Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1LVTXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:23:23 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:37266 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LVTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:23:19 -0500
Date: Thu, 22 Dec 2011 14:22:04 -0500 (EST)
Message-Id: <20111222.142204.1686212571308551442.davem@davemloft.net>
To: peterz@infradead.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        catalin.marinas@arm.com
Subject: Re: [RFC][PATCH] sparc64: remove __ARCH_WANT_UNLOCKED_CTXSW usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324581399.24803.38.camel@twins>
References: <20111221.164426.1859065550459950375.davem@davemloft.net>
	<20111221.180549.2295489434558987482.davem@davemloft.net>
	<1324581399.24803.38.camel@twins>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 22 Dec 2011 11:22:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 22 Dec 2011 20:16:39 +0100

> ARM being the last user of that feature, and with only SPARC64 and IA64
> (needlessly) using __ARCH_WANT_UNLOCKED_CTXSW we could finally remove
> some of that hairy code from the core scheduler.

W00t! :-)
