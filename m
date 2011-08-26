Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1HZQh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:37:29 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48472 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab1HZQh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:37:28 -0400
Date: Fri, 26 Aug 2011 12:36:20 -0400 (EDT)
Message-Id: <20110826.123620.2128524809929669115.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-08-26
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110826151758.GH2579@tuxdriver.com>
References: <20110826151758.GH2579@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 26 Aug 2011 09:36:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 26 Aug 2011 11:17:58 -0400

> Here is a round of fixes intended for 3.1...
> 
> The biggest portion are Bluetooth fixes.  Gustavo describes them
> thusly:
> 
> 	Some fixes for 3.1! It looks a lot of fixes but some of them
> 	are the same fix applied to different files. Here we have a
> 	fix for a wrong timer value from Chen Ganir, a lock balance
> 	fix from Dan Carpenter, regression fix with the HCI Reset
> 	command from Szymon Janc, a fix to not show error messages on
> 	btusb device disconnect from Paul Bolle. Support for Toshiba
> 	AR30XX from Ricardo Mendoza. And finally a bunch of fixes
> 	from Peter Hurley, there are some lost wake up, deadlocks and
> 	memort leaks fixes. Most of them fixes regressions introduced
> 	by the move to the kthread API.
> 
> In addition, we have a locking fix for carl9170, a bcma fix to enable
> driver loading via udev, a wl12xx fix to properly advertise the
> maximum number of SSIDs for scanning, another wl12xx fix to properly
> check a return code in order to avoid a possible oops, and a third
> wl12xx fix to remove a broken testmode function with locking problems
> (among others).  Also included is a suspend/resume fix for ath9k,
> a fix for reading improper MAC addresses on ath9k, a suspend/resume
> fix for mac80211, and a suspend/resume fix for rt2x00 as well.

Pulled, thanks John!
