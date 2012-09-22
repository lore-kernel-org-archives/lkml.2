Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab2IVTvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 15:51:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34863 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2IVTvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 15:51:42 -0400
Date: Sat, 22 Sep 2012 15:51:33 -0400 (EDT)
Message-Id: <20120922.155133.484429173339077143.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-09-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120922171341.GB2101@tuxdriver.com>
References: <20120922171341.GB2101@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Sat, 22 Sep 2012 13:13:42 -0400

> Please pull this last(?) batch of fixes intended for 3.6...
> 
> For the Bluetooth bits, Gustavo says this:
> 
> "Here goes probably my last update to 3.6. It includes the two patches
> you were ok last week(from Andrzej Kaczmarek), those are critical
> ones, and two other fixes one for a system crash and the other for
> a missing lockdep annotation."
> 
> The referenced fixes from Andrzej prevent attempts to configure devices
> that are powered-off.
> 
> Along with the Bluetooth fixes, there are a couple of 802.11 fixes.
> Emmanuel Grumbach gives us an iwlwifi fix to prevent releasing an
> interrupt twice.  Luis R. Rodriguez provides a fix for a possible
> circular lock dependency in the cfg80211 regulatory enforcement code.
> 
> All of these have been in linux-next for a few days.  I hope they are
> not too late to make the 3.6 release!

Pulled, thanks John.
