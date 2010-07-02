Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab0GBAfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:35:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34915
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965Ab0GBAfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:35:38 -0400
Date: Thu, 01 Jul 2010 17:35:50 -0700 (PDT)
Message-Id: <20100701.173550.172604489.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2010-07-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100701181526.GA2356@tuxdriver.com>
References: <20100701181526.GA2356@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 1 Jul 2010 14:15:27 -0400

> Two weeks since the last request, plenty of new stuff intended for
> 2.6.36...
> 
> Included are the usual bunch of driver updates, including a big
> dump from the rt2x00 team.  This also includes cfg80211 support
> for libertas, a flurry of (mostly trivial) stuff from me, and a
> wireless-2.6 pull to resolve some patch dependencies.
> 
> Please let me know if there are problems!

This failed to pull cleanly, I got a conflict in
drivers/net/wireless/libertas/host.h  It was the
usual "__packed" vs. "__attribute__((packed))" thing.

I resolved it but I wonder if this happened because you
did the wireless-2.6 --> wireless-next-2.6 merge here.
