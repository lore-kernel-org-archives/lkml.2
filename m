Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2DRTdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:33:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40851 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2DRTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:33:06 -0400
Date: Wed, 18 Apr 2012 15:31:58 -0400 (EDT)
Message-Id: <20120418.153158.1057856043612723800.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-04-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120418184320.GA2436@tuxdriver.com>
References: <20120418184320.GA2436@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 Apr 2012 12:32:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 18 Apr 2012 14:43:20 -0400

> First up, we have a minor signedness fix for libertas from Amitkumar
> Karwar.  Next, Arend gives us a brcm80211 fix for correctly enabling
> Tx FIFOs on channels 12 and 13.  Bing Zhao gives us some register
> address corrections for mwifiex.  Felix give us a trio of fixes --
> one for ath9k to wake the hardware properly from full sleep, one for
> mac80211 to properly handle packets in cooked monitor mode, and one
> for ensuring that the proper HT mode selection is honored.
> 
> Hauke gives us a bcma fix for handling the lack of an sprom.  Jonathon
> Bither gives us an ath5k fix for a missing THIS_MODULE build issue,
> and another ath5k fix for an io mapping leak.  Lukasz Kucharczyk
> fixes a bitwise check in cfg80211, and Sujith gives us an ath9k fix
> for assigning sequence numbers for fragmented frames.  Finally, we
> have a MAINTAINERS change from Wey-Yi Guy -- congrats to Johannes
> Berg for taking the lead on iwlwifi. :-)

:-)  Pulled, thanks.
