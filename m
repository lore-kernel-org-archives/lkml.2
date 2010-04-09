Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0DIRDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 13:03:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34355
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab0DIRDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 13:03:38 -0400
Date: Fri, 09 Apr 2010 10:03:41 -0700 (PDT)
Message-Id: <20100409.100341.268115452.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: jeff.chua.linux@gmail.com, shanyu.zhao@intel.com,
       reinette.chatre@intel.com, stable@kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, wey-yi.w.guy@intel.com,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-04-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100409153807.GA3014@tuxdriver.com>
References: <20100408200218.GC2999@tuxdriver.com>
	<1270762107.20845.3.camel@wwguy-ubuntu>
	<20100409153807.GA3014@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 9 Apr 2010 11:38:07 -0400

> This fix is intended for 2.6.34.  It resolves an issue involving an
> Oops on boxes w/ iwl4965 hardware, apparently introduced by another
> recent patch.  The thread describing the issue and the resolution
> is here:
> 
> 	http://marc.info/?l=linux-kernel&m=127074721531649&w=2
> 
> In order to avoid reverting that patch, please accept this fix instead.
> As usual, please let me know if there are problems!

Pulled, thanks John.
