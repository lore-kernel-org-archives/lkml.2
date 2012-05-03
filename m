Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2ECBio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 21:38:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38541 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2ECBim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 21:38:42 -0400
Date: Wed, 02 May 2012 21:35:32 -0400 (EDT)
Message-Id: <20120502.213532.2065398707446945634.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linville@tuxdriver.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ashok@cozybit.com,
        netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the wireless-next tree with the
 net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120503113110.3eded43c5dc526a471c69dd2@canb.auug.org.au>
References: <20120503113110.3eded43c5dc526a471c69dd2@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 02 May 2012 18:35:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 3 May 2012 11:31:10 +1000

> Today's linux-next merge of the wireless-next tree got a conflict in
> net/wireless/nl80211.c between commit 9360ffd18597 ("wireless: Stop using
> NLA_PUT*()") from the net-next tree and commit 0a9b3782ef40 ("{nl,cfg,mac}
> 80211: Allow user to see/configure HT protection mode") from the
> wireless-next tree.

John, the NLA_PUT macros were removed from the net-next tree more
than a month ago.

There is zero reason why this should still be happening, and this
issue is causing a large, unnecessary, burdon upon Stephen.

Please take care of this, thanks.
