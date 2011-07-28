Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1G1FYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:24:03 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1G1FXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:23:55 -0400
Date: Wed, 27 Jul 2011 22:22:47 -0700 (PDT)
Message-Id: <20110727.222247.2000159983502866405.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2011-07-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110727184920.GB16431@tuxdriver.com>
References: <20110727184920.GB16431@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 27 Jul 2011 22:22:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 27 Jul 2011 14:49:21 -0400

> Here is a handful of fixes intended for 3.1.  This includes a
> user-visible typo fix, a fix for a user after free in the new pn533
> NFC driver, a cfg80211 fix for a possible NULL pointer dereference,
> a fix for an invalid memory access in b43, and another b43 fix for
> a memory corruption problem.
> 
> On top of that b43 memory corruption fix, there is a patch to remove
> BROKEN from the B43_BCMA Kconfig entry, which is key to enabling
> support for some of the more modern Broadcom wireless hardware.
> I'm sure the Rafa©© (and a number of others) would love to see that
> merged while the 3.1 merge window is still open as well.
> 
> Please let me know if there are problems...

Yep, removing BROKEN from b43 seems reasonable.

Pulled, thanks!
