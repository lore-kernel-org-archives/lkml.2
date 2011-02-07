Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab1BGE1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 23:27:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43515
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652Ab1BGE1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 23:27:48 -0500
Date: Sun, 06 Feb 2011 20:28:24 -0800 (PST)
Message-Id: <20110206.202824.260090071.davem@davemloft.net>
To: andrew.hendry@gmail.com
Cc: apw@canonical.com, john@calva.com, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tim.gardner@canonical.com
Subject: Re: x25: possible skb leak on bad facilities
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTik-ywwtNg2AxAXtsKYJviDp=1zCZ-43JXp9i3g6@mail.gmail.com>
References: <20110131130826.GC16804@shadowen.org>
	<AANLkTik-ywwtNg2AxAXtsKYJviDp=1zCZ-43JXp9i3g6@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Hendry <andrew.hendry@gmail.com>
Date: Tue, 1 Feb 2011 22:55:13 +1100

> There are two callers, when I was crashing it I don't remember it
> using the backlog path.
> x25_process_rx_frame is called from both x25_backlog_rcv and also
> x25_receive_data (via x25_lapb_receive_frame)
> 
> But reviewing that second path now it looks like it will also leak, -1
> would make it skip the kfree_skb there as well.
> So patch looks good to me, when I have some time I'll run it through
> the environment I had setup originally to confirm.

Andrew, have you had a chance to do this yet?
