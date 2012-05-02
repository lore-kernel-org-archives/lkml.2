Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab2EBEGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 00:06:43 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56227 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2EBEGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 00:06:42 -0400
Date: Wed, 02 May 2012 00:05:23 -0400 (EDT)
Message-Id: <20120502.000523.307160882398092059.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-05-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120501183157.GA2987@tuxdriver.com>
References: <20120501183157.GA2987@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 01 May 2012 21:05:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 1 May 2012 14:31:58 -0400

> Part of these are Bluetooth -- Gustavo says:
> 
> "A few more fixes to 3.4, there is three new device id supported, a missing
> break and a fix to retain key during the connection."
> 
> Along with those, we have some 802.11 fixes.  Felix gives us a fix
> for sending EAP frames for AP VLAN interfaces.  Franky gives us
> two brcmfmac fixes, one for missed event completions and another
> for an improperly initialized function pointer.  Grazvydas Ignotas
> gives us a couple of wl1251 fixes for some improperly freed memory.
> Jonathan Bither gives us an ath5k fix for an AHB resource leak.
> Seth Forshee gives us a b43 fix to avoid a crash when b43 fails to
> properly initialize.  Finally, Wey-yi gives us a fixup for a previously
> merged fix to use the correct firmware for certain iwlwifi devices.
> 
> The brcmfmac fixes are bigger than I would like to see.  But since
> they are isolated to that driver and fix real problems, I felt they
> were still acceptable.
> 
> Please let me know if there are problems!

Pulled, thanks John.
