Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2BTAGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:06:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40728 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2BTAG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:06:28 -0500
Date: Sun, 19 Feb 2012 19:05:36 -0500 (EST)
Message-Id: <20120219.190536.1601398467747959636.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, vapier@gentoo.org, sonic.zhang@analog.com,
        jeffrey.t.kirsher@intel.com, bob.liu@analog.com,
        uclinux-dist-devel@blackfin.uclinux.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] adi: adapt to eth_hw_addr_random() and changes
 in arch/blackfin
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329412171-20704-3-git-send-email-danny.kukawka@bisect.de>
References: <1329412171-20704-1-git-send-email-danny.kukawka@bisect.de>
	<1329412171-20704-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 19 Feb 2012 16:05:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Thu, 16 Feb 2012 18:09:31 +0100

> Adapt adi ethernet driver to changes in bfin_get_ether_addr()
> from arch/blackfin. bfin_get_ether_addr() returns now a state.
> Set a random mac address via new eth_hw_addr_random() in case
> the return value is not 0.
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> v2: change the logic to reduce unneeded checks
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
