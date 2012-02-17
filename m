Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2BQVBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:01:23 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54699 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2BQVBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:01:22 -0500
Date: Fri, 17 Feb 2012 16:01:04 -0500 (EST)
Message-Id: <20120217.160104.2216743770253883286.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: jeffrey.t.kirsher@intel.com, dkukawka@suse.de, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        peter.p.waskiewicz.jr@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/10] igbvf: reset netdevice addr_assign_type if
 changed
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329493411-25750-6-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-6-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 13:01:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 16:43:26 +0100

> Reset the state of addr_assign_type to NET_ADDR_PERM as soon as
> the MAC get changed via .ndo_set_mac_address.
> 
> v2: use bitops to reset addr_assign_type
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
