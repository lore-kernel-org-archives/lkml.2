Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2DATVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 15:21:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44006 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2DATVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 15:21:44 -0400
Date: Sun, 01 Apr 2012 15:19:37 -0400 (EDT)
Message-Id: <20120401.151937.436689731888432426.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.4-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120401220340.57df6c1fe19ffd7070bc552f@canb.auug.org.au>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
	<20120401220340.57df6c1fe19ffd7070bc552f@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 01 Apr 2012 12:19:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Sun, 1 Apr 2012 22:03:40 +1000

> Well, we may have avoided some of that pain (or at least moved the pain
> out of your tree while you were merging everything else) by putting the
> system.h disintegration into linux-next for at least a day or two ...

I was really surprised this didn't soak in linux-next for a little
while first.   All of those sparc build regressions, I can guarantee,
would have been sorted out completely before being merged to Linus.
