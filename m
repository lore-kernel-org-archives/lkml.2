Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1HSNiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:38:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52331 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1HSN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:22 -0400
Date: Fri, 19 Aug 2011 06:26:09 -0700 (PDT)
Message-Id: <20110819.062609.1865751197015675220.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, davidb@codeaurora.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: of_iomap() matched with plan iounmap()
From: David Miller <davem@davemloft.net>
In-Reply-To: <201108191426.19152.arnd@arndb.de>
References: <20110818170226.GA16721@huya.qualcomm.com>
	<20110818.203447.462383652600224162.davem@davemloft.net>
	<201108191426.19152.arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 19 Aug 2011 06:26:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 19 Aug 2011 14:26:18 +0200

> We could of course change all existing users of of_iounmap on sparc to use
> the simpler prototype, because it also just calls iounmap.

Check again, on sparc64 it needs the resource to release it.

Only the 32-bit version on sparc evaluates to just a plain iounmap().
