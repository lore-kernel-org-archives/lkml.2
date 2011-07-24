Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1GXKLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 06:11:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35007 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1GXKLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 06:11:08 -0400
Date: Sun, 24 Jul 2011 03:09:49 -0700 (PDT)
Message-Id: <20110724.030949.1727841105144911931.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2011-07-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110722.171635.1154932336401179368.davem@davemloft.net>
References: <20110722222308.GA3048@tuxdriver.com>
	<20110722.171635.1154932336401179368.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 24 Jul 2011 03:09:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 22 Jul 2011 17:16:35 -0700 (PDT)

> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Fri, 22 Jul 2011 18:23:09 -0400
> 
>> Here is the last big pull request of new wireless bits intended
>> for 3.1.  This includes the usual big batch of updates to iwlagn,
>> a number of updates to ath9k, mwifiex, carl9170, libertas, and other
>> drivers, and soem updates to mac80211 and cfg80211 from Johannes.
>> The most noteworth bits are most of the final push from Rafa©© for
>> supporting current Broadcom wireless hardware in b43.
>> 
>> Please let me know if there are problems!
> 
> A little late to be submitting this since the merge window is
> already open, but I pulled anyways.
> 
> Thanks!

Please fix this build regression, the suspend/resume ops are only
available when CONFIG_PM is defined.

drivers/net/wireless/iwlwifi/iwl-agn.c:3464: error: unknown field 'suspend' specified in initializer
drivers/net/wireless/iwlwifi/iwl-agn.c:3464: warning: initialization from incompatible pointer type
drivers/net/wireless/iwlwifi/iwl-agn.c:3465: error: unknown field 'resume' specified in initializer
drivers/net/wireless/iwlwifi/iwl-agn.c:3465: warning: initialization from incompatible pointer type
 
