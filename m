Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab2LNSQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:16:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48888 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2LNSQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:16:17 -0500
Date: Fri, 14 Dec 2012 13:16:15 -0500 (EST)
Message-Id: <20121214.131615.1528694276738811674.davem@davemloft.net>
To: khlebnikov@openvz.org
Cc: linux-kernel@vger.kernel.org, dbaryshkov@gmail.com, netdev@vger.kernel.org,
        alex.bluesman.smirnov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net
Subject: Re: [PATCH 10/12] mac802154: fix destructon ordering for
 ieee802154 devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121214110303.11019.41133.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
	<20121214110303.11019.41133.stgit@zurg>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Fri, 14 Dec 2012 15:03:03 +0400

> mutex_destroy() must be called before wpan_phy_free(), because it puts the last
> reference and frees memory. Catched as overwritten poison in kmalloc-2048.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Applied.
