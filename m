Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2DQUrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:47:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58517 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2DQUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:47:51 -0400
Date: Tue, 17 Apr 2012 16:47:48 -0400 (EDT)
Message-Id: <20120417.164748.432392687904063236.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: a.beregalov@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.4.0-rc2: skb_put() -> skb_over_panic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334695506.2472.46.camel@edumazet-glaptop>
References: <1334502964.28012.1.camel@edumazet-glaptop>
	<CAA1sL1SJyY7fYJn7OKqo5Pa=b4-r9DW90-5WVGBf==tFjVEBpg@mail.gmail.com>
	<1334695506.2472.46.camel@edumazet-glaptop>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Apr 2012 13:47:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 17 Apr 2012 22:45:06 +0200

> Could you check if commit a21d45726acacc963d8baddf74607d9b74e2b723
> (tcp: avoid order-1 allocations on wifi and tx path)
> was in your tree ?

I was about to say that I think this is the guilty commit too.

Good thing I held off the -stable submission of that change
for a bit :-)
