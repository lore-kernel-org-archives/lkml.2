Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2BDVM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 16:12:28 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36057 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab2BDVM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 16:12:27 -0500
Date: Sat, 04 Feb 2012 16:11:19 -0500 (EST)
Message-Id: <20120204.161119.1004038103064439060.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-02-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120203192917.GE15601@tuxdriver.com>
References: <20120203192917.GE15601@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 04 Feb 2012 13:11:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 3 Feb 2012 14:29:18 -0500

> Here is a little batch of fixes intended for 3.3...
> 
> We have a fix from Eliad Peller for an off-by-one error in mac80211 that
> was preventing a timeout.  Emmanuel Grumbach provides an iwlwifi fix to
> avoid incorrect manipulations on non-QoS frames that were stalling the
> Tx queues.  Hauke Mehrtens provides another off-by-one fix, this one for
> the SSB bus.  Jesper Juhl provies us with a fix for a memory leak in the
> BCMA code.  A fix to avoid some log spam from iwlwifi is provided by me.
> Finally, Luigi Tarenga provides an rt2800 fix to correctly report signal
> strength.
 ...
> The following changes since commit 29830406415c227a54af429d7b300aabd4754237:
> 
>   can: peak_pci: Fix the way channels are linked together (2012-02-03 00:26:27 +0100)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git for-davem

Pulled, thanks John.
