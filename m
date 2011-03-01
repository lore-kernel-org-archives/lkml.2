Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1CAHY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 02:24:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38441
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100Ab1CAHYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 02:24:25 -0500
Date: Mon, 28 Feb 2011 23:25:02 -0800 (PST)
Message-Id: <20110228.232502.226763923.davem@davemloft.net>
To: acahalan@gmail.com
Cc: johnwheffner@gmail.com, linville@tuxdriver.com, eric.dumazet@gmail.com,
        jussi.kivilinna@mbnet.fi, swmike@swm.pp.se,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: txqueuelen has wrong units; should be time
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=eDQh9Kvr9N_dTC5Cnbcfb+DbO-6tLxkZiEp9v@mail.gmail.com>
References: <AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>
	<20110228.201852.193726064.davem@davemloft.net>
	<AANLkTi=eDQh9Kvr9N_dTC5Cnbcfb+DbO-6tLxkZiEp9v@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Albert Cahalan <acahalan@gmail.com>
Date: Tue, 1 Mar 2011 01:54:09 -0500

> In case it makes you feel any better, consider two cases
> where synchronous feedback is already impossible.
> One is when you're routing packets that merely pass through.
> The other is when some other box is doing that to you.
> Either way, packets go bye-bye and nobody tells TCP.

I consider ECN quite synchronous, and routers will set ECN bits to
propagate congestion information when they do or are about to drop
packets.
