Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1CAESR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 23:18:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41386
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414Ab1CAESQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 23:18:16 -0500
Date: Mon, 28 Feb 2011 20:18:52 -0800 (PST)
Message-Id: <20110228.201852.193726064.davem@davemloft.net>
To: acahalan@gmail.com
Cc: johnwheffner@gmail.com, linville@tuxdriver.com, eric.dumazet@gmail.com,
        jussi.kivilinna@mbnet.fi, swmike@swm.pp.se,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: txqueuelen has wrong units; should be time
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>
References: <20110228165501.GC2515@tuxdriver.com>
	<AANLkTinj5szpStmA+fZ1xggdyTS+sd8Y9jXaYquDNEjs@mail.gmail.com>
	<AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Albert Cahalan <acahalan@gmail.com>
Date: Mon, 28 Feb 2011 23:11:13 -0500

> It sounds like you need a callback or similar, so that TCP can be
> informed later that the drop has occurred.

By that point we could have already sent an entire RTT's worth
of data, or more.

It needs to be synchronous, otherwise performance suffers.
