Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab0DGXmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:42:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59041
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754811Ab0DGXmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:42:21 -0400
Date: Wed, 07 Apr 2010 16:42:24 -0700 (PDT)
Message-Id: <20100407.164224.60848141.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-04-07
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100407182832.GA2995@tuxdriver.com>
References: <20100407182832.GA2995@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 7 Apr 2010 14:28:32 -0400

> Here is a batch of fixes intended for 2.6.34.  Included is a variable
> initialization required for some ath9k hardware to function reliably,
> some RCU annotation to avoid some warnings in mac80211, and a fix for
> a regression relating to 802.11s mesh networking.  Also included are
> several iwlwifi fixes, include the elimination of an order-4 allocation
> during resume, avoidance of a the BUG_ON in the rate scaling routines,
> and the elimination of a DMA API warning during module removal.
> The iwlwifi patches are a little larger than I would like, but the
> fixes seem legitimate and worthwhile to me.

I guess nobody takes me seriously when I say tone down the rate
of fixes to the absolute minimum.

Oh well, what can I do, if even the most core people can't be bothered
to listen to my requests.

And people wonder why we need 8 or 9 RCs to get a release out.

Pulled.
