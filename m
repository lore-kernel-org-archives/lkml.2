Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0CQEba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:31:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51614
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720Ab0CQEb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:31:28 -0400
Date: Tue, 16 Mar 2010 21:31:49 -0700 (PDT)
Message-Id: <20100316.213149.00701940.davem@davemloft.net>
To: joe@perches.com
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
       jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
       alexander.h.duyck@intel.com, peter.p.waskiewicz.jr@intel.com,
       john.ronciak@intel.com, gallatin@myri.com, brice@myri.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH net-next] drivers/net/e100.c: Use pr_<level> and
 netif_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267478181.12641.142.camel@Joe-Laptop.home>
References: <cover.1266893507.git.joe@perches.com>
	<9929d2391002231833j65008a1ev1d2297672a39a483@mail.gmail.com>
	<1267478181.12641.142.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 01 Mar 2010 13:16:21 -0800

> Convert DPRINTK, commonly used for debugging, to netif_<level>
> Remove #define PFX
> Use #define pr_fmt
> Consistently use no periods for non-sentence logging messages
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
