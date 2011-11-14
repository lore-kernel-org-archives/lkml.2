Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1KNFPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:15:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55072 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1KNFPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:15:46 -0500
Date: Mon, 14 Nov 2011 00:15:14 -0500 (EST)
Message-Id: <20111114.001514.2212530697656360412.davem@davemloft.net>
To: david.decotigny@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, jpirko@redhat.com, joe@perches.com,
        szymon@janc.net.pl, rick.jones2@hp.com, AAbdulla@nvidia.com
Subject: Re: [PATCH FIX net v2] forcedeth: fix stats on hardware without
 extended stats support
From: David Miller <davem@davemloft.net>
In-Reply-To: <51c23650f3fc6e48b652a7ab322ca09a1cb7cbcc.1321064621.git.david.decotigny@google.com>
References: <cover.1321064621.git.david.decotigny@google.com>
	<51c23650f3fc6e48b652a7ab322ca09a1cb7cbcc.1321064621.git.david.decotigny@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:15:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <david.decotigny@google.com>
Date: Fri, 11 Nov 2011 18:27:34 -0800

> This change makes sure that tx_packets/rx_bytes ifconfig counters are
> updated even on NICs that don't provide hardware support for these
> stats: they are now updated in software. For the sake of consistency,
> we also now have tx_bytes updated in software (hardware counters
> include ethernet CRC, and software doesn't account for it).
> 
> This reverts parts of:
>  - "forcedeth: statistics optimization" (21828163b2)
>  - "forcedeth: Improve stats counters" (0bdfea8ba8)
>  - "forcedeth: remove unneeded stats updates" (4687f3f364)
> 
> Tested:
>   pktgen + loopback (http://patchwork.ozlabs.org/patch/124698/)
>   reports identical tx_packets/rx_packets and tx_bytes/rx_bytes.
> 
> Signed-off-by: David Decotigny <david.decotigny@google.com>

Applied, thanks.
