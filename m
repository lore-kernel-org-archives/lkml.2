Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab1KVXTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 18:19:08 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55363 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912Ab1KVXTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 18:19:06 -0500
Date: Tue, 22 Nov 2011 18:17:57 -0500 (EST)
Message-Id: <20111122.181757.1296497307756213535.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-11-22 #2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111122224108.GJ8452@tuxdriver.com>
References: <20111122215611.GI8452@tuxdriver.com>
	<20111122.173729.1155753802137219940.davem@davemloft.net>
	<20111122224108.GJ8452@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 Nov 2011 15:18:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 22 Nov 2011 17:41:08 -0500

> On Tue, Nov 22, 2011 at 05:37:29PM -0500, David Miller wrote:
> ...
> They're here...
> 
>> 0003-rt2x00-Fix-efuse-EEPROM-reading-on-PPC32.patch
>> 0004-p54spi-Add-missing-spin_lock_init.patch
>> 0005-p54spi-Fix-workqueue-deadlock.patch
>> 0006-mac80211-Fix-AMSDU-rate-printout-in-debugfs.patch
>> 0007-mac80211-Fix-endian-bug-in-radiotap-header-generatio.patch
>> 0008-cfg80211-fix-regulatory-NULL-dereference.patch
>> 0009-prism54-potential-memory-corruption-in-prism54_get_e.patch
>> 0010-Revert-rt2x00-handle-spurious-pci-interrupts.patch
>> 0011-Revert-rt2800pci-handle-spurious-interrupts.patch
> 
> And I revert them here.
> 
> Linus always says to live with our mistakes?  I was trying to avoid
> a rebase both for my own pain and that of my downstream maintainers.

Gotcha, I'll repull, thanks.
