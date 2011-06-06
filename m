Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab1FFU0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:26:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53838 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab1FFU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:26:54 -0400
Date: Mon, 06 Jun 2011 13:25:49 -0700 (PDT)
Message-Id: <20110606.132549.1074295213687787615.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-06-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110606190427.GH2604@tuxdriver.com>
References: <20110606190427.GH2604@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 06 Jun 2011 13:25:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 6 Jun 2011 15:04:27 -0400

> Here are a few more fixes intended for 3.0 -- a libertas fix for a
> regression related to spurious interrupts, an ath5k fix to disable
> "fast" channel switching (since it caused a number of devices to
> regress in performance), an ssb fix for a regression that was applying
> PCIe workarounds to PCI devices (causing a machine check), an fix for an
> iwlagn locking regression, and a mac80211 fix for a device-naming
> regression.
> 
> Please let me know if there are problems!

Pulled, thanks John.
