Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2JJQGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:06:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50431 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab2JJQGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:06:48 -0400
Date: Wed, 10 Oct 2012 12:06:45 -0400 (EDT)
Message-Id: <20121010.120645.144599458222040514.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-10-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121009183844.GB1993@tuxdriver.com>
References: <20121009183844.GB1993@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 9 Oct 2012 14:38:44 -0400

> Here is a batch of fixes intended for 3.7...
> 
> Amitkumar Karwar provides a couple of mwifiex fixes to correctly
> report some reason codes for certain connection failures.  He also
> provides a fix to cleanup after a scanning failure.  Bing Zhao rounds
> that out with another mwifiex scanning fix.
> 
> Daniel Golle gives us a fix for a copy/paste error in rt2x00.
> 
> Felix Fietkau brings a couple of ath9k fixes related to suspend/resume,
> and a couple of fixes to prevent memory leaks in ath9k and mac80211.
> 
> Ronald Wahl sends a carl9170 fix for a sleep in softirq context.
> 
> Thomas Pedersen reorders some code to prevent drv_get_tsf from being
> called while holding a spinlock, now that it can sleep.
> 
> Finally, Wei Yongjun prevents a NULL pointer dereference in the
> ath5k driver.
 ...
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git tags/master-2012-10-08

Pulled, thanks John.
