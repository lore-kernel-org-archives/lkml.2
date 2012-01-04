Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab2ADTua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:50:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52302 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab2ADTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:50:28 -0500
Date: Wed, 04 Jan 2012 14:49:23 -0500 (EST)
Message-Id: <20120104.144923.372584452455227614.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-01-04 #2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120104164339.GG2540@tuxdriver.com>
References: <20120104164339.GG2540@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Jan 2012 11:49:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 4 Jan 2012 11:43:40 -0500

> Here are a handful of straggler wireless fixes for 3.2.  Included is
> a NULL pointer fix for mwifiex, a regression fix for handling rx
> header lengths for differnt b43 firmwares in PIO mode, a revert of
> a one-liner for Bluetooth HCI that was causing uncomfortable delays
> during resume, and an ath9k fix for a panic when running in AP mode
> with aggregation disabled.
> 
> The Bluetooth fix is a one-liner change of a delay value.  The mwifiex,
> b43, and ath9k fixes are relatively small and isolated to their
> respective drivers.
> 
> Please let me know if there are problems!
...
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git for-davem

Pulled, thanks.
