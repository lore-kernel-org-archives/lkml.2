Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab0KVPgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 10:36:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52408
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199Ab0KVPgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 10:36:21 -0500
Date: Mon, 22 Nov 2010 07:36:46 -0800 (PST)
Message-Id: <20101122.073646.193727189.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: mhocko@suse.cz, linux-wireless@vger.kernel.org, reinette.chatre@intel.com,
        wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: iwl3945: regression - unregister_netdevice: waiting for wlan0
 to become free. Usage count = 1
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290424776.2811.32.camel@edumazet-laptop>
References: <20101122104341.GA3897@tiehlicka.suse.cz>
	<1290424776.2811.32.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 22 Nov 2010 12:19:36 +0100

> Oh well, it seems David put the fix in net-next-2.6 instead of net-2.6
> 
> Please try :
> 
> http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commitdiff;h=9d82ca98f71fd686ef2f3017c5e3e6a4871b6e46

My bad, I'll toss this into net-2.6

Thanks for catching this Eric.
