Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1BHUOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:14:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44206
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851Ab1BHUOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:14:21 -0500
Date: Tue, 08 Feb 2011 12:14:56 -0800 (PST)
Message-Id: <20110208.121456.189701516.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-02-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110208195530.GB6244@tuxdriver.com>
References: <20110208195530.GB6244@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 8 Feb 2011 14:55:30 -0500

> Here is the latest round of wireless fixes intended for 2.6.38.
> Included is a carl9170 fix (described as a typo) for receiving buffered
> broadcasts, an iwlagn fix to properly monitor the rfkill switch when
> the interface is down, a mac80211 fix to correctly check for cloned
> skbs when resizing, a null pointer fix for wl1251 if it fails to get
> a beacon, a mac80211 fix related to off-channel tx, an ssb fix for
> using the wrong pointer for getting invariance for pcmcia devices,
> an ath9k double-free fix, and a one-line iwlagn fix to correctly
> describe an antenna configuration.

Pulled, thanks John.
