Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1HCAID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 20:08:03 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46461 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1HCAHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 20:07:55 -0400
Date: Tue, 02 Aug 2011 17:06:37 -0700 (PDT)
Message-Id: <20110802.170637.389945963010848876.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2011-08-02
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110802.143955.1785360722763378138.davem@davemloft.net>
References: <20110802181131.GH14167@tuxdriver.com>
	<20110802.143955.1785360722763378138.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 02 Aug 2011 17:06:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 02 Aug 2011 14:39:55 -0700 (PDT)

> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Tue, 2 Aug 2011 14:11:31 -0400
> 
>> Here are a few more fixes intended for 3.1.  Dan Carpenter gives us an
>> off-by-one fix in the scan trigger code for nl80211.  Felix gives us a
>> fix for tx power initialization for ath9k.  Larry fixes an oops on ARM
>> by rewriting some init code to avoid checking something that doesn't get
>> initialized on ARM.  This round's big hero is Stanislaw, who gives us a
>> brown paper bag fix for some skb handling in rt2x00, an ath9k fix to
>> avoid hangs on systems w/ ASPM disabled, and an iwlegacy fix to ensure
>> that tx power settings are applied properly.
>> 
>> Please let me know if there are problems!
> 
> I'll pull this, but I think once you've sent me all of your features
> for the merge window you should drop "-next" from the name of the
> tree and/or branches you ask me to pull from.
> 
> This makes it entirely clear that you're sending me bug fixes and not
> features and cleanups.

Well, this thing is not based upon the plain net GIT tree, because
when I pull it I get a bunch of things from Linus's tree which are
not in the net tree yet.

Please fix this up.

Thanks.
