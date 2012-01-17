Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab2AQBQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:16:19 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48568 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2AQBQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:16:17 -0500
Date: Mon, 16 Jan 2012 20:15:07 -0500 (EST)
Message-Id: <20120116.201507.597966888285215358.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-01-16
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120116195435.GB12733@tuxdriver.com>
References: <20120116195435.GB12733@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 16 Jan 2012 17:15:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 16 Jan 2012 14:54:35 -0500

> Here is a set of fixes for 3.3 that I let cook over the weekend...
> 
> Included is a fix for a signedness bug in ipw2x00 from Dan Carpenter, a
> fix for an oops when ejecting a b43 card from Guennadi Liakhovetski
> (with a minor modification by me as noted in the changelog), a mac80211
> regresion fix from Johannes Berg for a bug related to station
> management, and a final fix for the rt2800pci spurious interrupt issue
> from Stanislaw Gruszka.

And Linus's patches to fix the brcmsmac driver aren't in here because?

If you don't integrate them, Linus is going to integrate them on his
own before -rc1 is cut, so whatever you're "waiting for" is entirely
and utterly pointless.

Merge his bug fixes now, don't delay this kind of stuff, ever.
