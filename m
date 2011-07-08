Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1GHQfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 12:35:05 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53881 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1GHQfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 12:35:03 -0400
Date: Fri, 08 Jul 2011 09:33:57 -0700 (PDT)
Message-Id: <20110708.093357.1592862635180925238.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-07-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110708162144.GA15143@tuxdriver.com>
References: <20110708162144.GA15143@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 08 Jul 2011 09:33:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 8 Jul 2011 12:21:44 -0400

> Here is a final(?) batch of wireless-related fixes intended for 3.0.
> Included are a fix for a TKIP replay vulnerability from Johannes, a
> locking fix related to rfkill and a memory corruption fix from Luca,
> an SSB initialization fix from Rafa©©, an ath9k performance regression
> fix from Rajkumar, and some fixes from Pavel for sysfs bad pointer
> accesses in ath5k.
> 
> Also included are some Bluetooth fixes.  Gustavo described them thusly:
> 
> 	There are here two regression fixes, a hidp deadlock hang up
> 	of the system fix from Peter Hurley. As the commit messages
> 	says it is a partial revert from a commit that adds kthread
> 	to hidp. And L2CAP incoming connection request fix that
> 	was breaking one test in the PTS suit, that is, breaking
> 	interop. Patch is based on code from Ilia Kolomisnky.  Also,
> 	a buffer overflow fix by Dan Rosenberg and finally Tomas
> 	Targownik fixed a memory leak on failed connections attempts
> 	that seems to be around since 2006!!
> 
> I also included a couple of device ID additions -- I hope that's OK.
> 
> Please let me know if there are problems!

Pulled, thanks!
