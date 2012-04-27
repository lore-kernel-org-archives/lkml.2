Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307Ab2D0TYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:24:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45011 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760458Ab2D0TYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:24:33 -0400
Date: Fri, 27 Apr 2012 15:24:04 -0400 (EDT)
Message-Id: <20120427.152404.2292425516870981391.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        raven@themaw.net, thomas@m3y3r.de, stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
References: <20120427.151433.1007849975903946491.davem@davemloft.net>
	<20120427.151651.2274764174217164454.davem@davemloft.net>
	<CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 Apr 2012 12:24:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 12:19:56 -0700

> Btw, I think I may have an alternate fix. Which is to simply add a
> "packetized" mode to pipes.

If you can pull that off, it would certainly work and be the best
solution.

BTW, this has happened before, we had this same problem passing data
over netlink sockets.  And since it's packetized already we had a
slightly easier time dealing with it.
