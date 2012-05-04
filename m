Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023Ab2EDQIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:08:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54808 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2EDQIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:08:46 -0400
Date: Fri, 04 May 2012 12:07:36 -0400 (EDT)
Message-Id: <20120504.120736.1896153625895120398.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kerenl.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-05-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120503173749.GQ9285@tuxdriver.com>
References: <20120503173749.GQ9285@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 04 May 2012 09:07:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 3 May 2012 13:37:50 -0400

> Here is another trio of fixes intended for 3.4.  The fix from Eric
> Dumazet corrects skb truesize reporting in iwlwifi, avoiding a
> potential exhaustion of kernel memory due to differet socket memory
> accounting for these skb allocations.  The fix from Franky Lin avoids
> a double unlock on a spinlock in brcmfmac.  Finally, Rajkumar Manoharan
> reverts an earlier patch that created a minor regression in ath9k.

Pulled, thanks John.
