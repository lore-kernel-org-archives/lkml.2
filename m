Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1KNTuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:50:32 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52797 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1KNTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:50:31 -0500
Date: Mon, 14 Nov 2011 14:49:25 -0500 (EST)
Message-Id: <20111114.144925.1878369827907627467.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-11-14
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111114193253.GA2499@tuxdriver.com>
References: <20111114193253.GA2499@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 Nov 2011 11:49:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 14 Nov 2011 14:32:54 -0500

> Here is another batch of fixes intended for 3.2.  This includes an
> mwifiex fix to enable association with "hidden" APs, a fix for avoiding
> an unhandled RF kill interrupt when unloading iwlwifi, a NULL pointer
> fix in the mac80211 radiotap code, a fix for ieee80211_build_probe_req
> to pass-up a proper return code when ieee80211_probereq_get fails, a
> race fix for mac80211 to avoid a WARNING in ieee80211_can_queue_work, a
> NULL pointer fix in the cfg80211 regulatory code, and a fix for an
> unaligned memory access in the libertas driver.
 ...
> The following changes since commit 1e49570171117e547e6324c58371db4a0dc2f1db:
> 
>   net: Fix references to deleted NET_ETHERNET Kconfig setting. (2011-11-09 19:26:53 -0500)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git for-davem

Pulled, thanks John!
