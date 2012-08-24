Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056Ab2HXTSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:18:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55706 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2HXTSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:18:47 -0400
Date: Fri, 24 Aug 2012 15:18:43 -0400 (EDT)
Message-Id: <20120824.151843.2224438277546850875.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-08-24
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120824161330.GC27147@tuxdriver.com>
References: <20120824161330.GC27147@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 24 Aug 2012 12:13:31 -0400

> This batch of fixes is intended for 3.6...
> 
> Johannes Berg gives us a pair of iwlwifi fixes.  One corrects some
> improperly defined ifdefs that lead to crashes and BUG_ONs.  The other
> prevents attempts to read SRAM for devices that aren't actually started.
> 
> Julia Lawall provides an ipw2100 fix to properly set the return code
> from a function call before testing it! :-)
> 
> Thomas Huehn corrects the improper use of a constant related to a power
> setting in ath5k.
> 
> Thomas Pedersen offers a mac80211 fix to properly handle destination
> addresses of unicast frames passing though a mesh gate.
> 
> Vladimir Zapolskiy provides a brcmsmac fix to properly mark the
> interface state when the device goes down.

Pulled, thanks a lot John.
