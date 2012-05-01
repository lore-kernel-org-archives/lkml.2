Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2EABDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:03:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44587 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab2EABDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:03:39 -0400
Date: Mon, 30 Apr 2012 21:03:35 -0400 (EDT)
Message-Id: <20120430.210335.1697570355622765079.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: kaffeemonster@googlemail.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1335831987.20866.93.camel@pasglop>
References: <1335823049.20866.48.camel@pasglop>
	<4F9F12ED.1090009@googlemail.com>
	<1335831987.20866.93.camel@pasglop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Apr 2012 18:03:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 01 May 2012 10:26:27 +1000

> I don't see a good way to sort that out other than introducing a new
> kernel-side structure, change the sockopt number, and support the old
> one as backward binary compat, but that's gross.

First there are no padding issues, compat or otherwise.

Second, there is no reason to add a new data-structure.  Just make
them use the right one, sock_fprog, if they are making the socket
option call themselves.

I can't believe this discussion is still going on, there is nothing to
talk about.
