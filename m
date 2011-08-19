Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1HSFQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 01:16:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60478 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1HSFQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 01:16:38 -0400
Date: Thu, 18 Aug 2011 22:14:33 -0700 (PDT)
Message-Id: <20110818.221433.2023110799070604982.davem@davemloft.net>
To: warthog9@kernel.org
Cc: linux-kernel@vger.kernel.org, users@kernel.org
Subject: Re: [kernel.org users] [KORG] Taking hera down to deal with the
 load issues
From: David Miller <davem@davemloft.net>
In-Reply-To: <4E4B7664.9070301@kernel.org>
References: <4E4AFCFC.9020008@kernel.org>
	<4E4B7664.9070301@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 18 Aug 2011 22:14:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J.H." <warthog9@kernel.org>
Date: Wed, 17 Aug 2011 01:05:56 -0700

> This second kernel is at least, so far, acting a lot closer to what I'd
> expect from hera, but the disk cache is still filling.  I'm going to
> keep an eye on it for a bit longer tonight.  As a note, the only
> difference between the first 3.1-rc1 kernel and the second, that is
> currently running, was the explicit disabling of IMA and recompiling the
> kernel.

I wonder if the IMA bits are generating crypto hashes for every file
modification done on the machine.
