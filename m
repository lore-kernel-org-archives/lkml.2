Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1ERV0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:26:45 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49636 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1ERV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:26:43 -0400
Date: Wed, 18 May 2011 17:26:34 -0400 (EDT)
Message-Id: <20110518.172634.2102201592173243863.davem@davemloft.net>
To: decot@google.com
Cc: joe@perches.com, szymon@janc.net.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-net-upstream@google.com,
        snanda@google.com
Subject: Re: [PATCH] forcedeth: new ethtool stat "tx_timeout" to account
 for tx_timeouts
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTimNvuB5HtOKfAc7rf5wF2QeC3xdXw@mail.gmail.com>
References: <1305752945-14843-2-git-send-email-decot@google.com>
	<20110518.171416.1780927258138770742.davem@davemloft.net>
	<BANLkTimNvuB5HtOKfAc7rf5wF2QeC3xdXw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 14:26:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@google.com>
Date: Wed, 18 May 2011 14:20:21 -0700

> Hi David,
> 
> They should be independent and applicable in any order, except for the
> two 'PATCH x/2' which have to go together.

That doesn't matter.

When you are sending a set of patches, always number them.

Please resubmit your changes with my feedback incorporated, I'm
not applying what you sent until everything is fixed up.

Thanks.
