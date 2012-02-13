Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2BMFud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:50:33 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59169 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2BMFub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:50:31 -0500
Date: Mon, 13 Feb 2012 00:50:11 -0500 (EST)
Message-Id: <20120213.005011.1860393880116915900.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        peter.p.waskiewicz.jr@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com, mitch.a.williams@intel.com, jpirko@redhat.com,
        eric.dumazet@gmail.com, e1000-devel@lists.sourceforge.net,
        shemminger@vyatta.com
Subject: Re: [PATCH 2/2] rename dev_hw_addr_random and remove redundant
 second
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328816934-11508-3-git-send-email-danny.kukawka@bisect.de>
References: <1328816934-11508-1-git-send-email-danny.kukawka@bisect.de>
	<1328816934-11508-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 12 Feb 2012 21:50:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Thu,  9 Feb 2012 20:48:54 +0100

> Renamed dev_hw_addr_random to eth_hw_addr_random() to reflect that
> this function only assign a random ethernet address (MAC). Removed
> the second parameter (u8 *hwaddr), it's redundant since the also
> given net_device already contains net_device->dev_addr.
> Set it directly.
> 
> Adapt igbvf and ixgbevf to the changed function.
> 
> Small fix for ixgbevf_probe(): if ixgbevf_sw_init() fails
> (which means the device got no dev_addr) handle the error and
> jump to err_sw_init as already done by igbvf in similar case.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
