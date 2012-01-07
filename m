Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404Ab2AGCHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 21:07:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45440 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355Ab2AGCHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 21:07:47 -0500
Date: Fri, 06 Jan 2012 18:07:45 -0800 (PST)
Message-Id: <20120106.180745.694506225640408539.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwbykuZ30i2qrdAbX=PzRC5jtOYuAk8s8j47OP7qDSM8g@mail.gmail.com>
References: <CA+55aFyk6QJib8UCtK_gWzidr8Ti1utJgHg359fkq=+GY8hbnw@mail.gmail.com>
	<20120106.175028.1076280359661712542.davem@davemloft.net>
	<CA+55aFwbykuZ30i2qrdAbX=PzRC5jtOYuAk8s8j47OP7qDSM8g@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 06 Jan 2012 18:07:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2012 17:55:13 -0800

> Look, I have a *recent* distro (up-to-date F16) and the tool that is
> mentioned (ss) doesn't actually use the new feature even when compiled
> in.
> 
> So it doesn't "replace" anything, and buys normal people nothing at all.
> 
> Some day, maybe. Today? No. It's pure baggage. It shouldn't be "default y".

Oh I see.

Ok, we can take away those default Kconfig tags for the UDP and AF_UNIX
bits, no problem.
