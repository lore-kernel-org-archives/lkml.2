Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab0KAQds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:33:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59935
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815Ab0KAQdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:33:46 -0400
Date: Mon, 01 Nov 2010 09:34:09 -0700 (PDT)
Message-Id: <20101101.093409.189716653.davem@davemloft.net>
To: dkirjanov@kernel.org
Cc: mad_soft@inbox.ru, dbrownell@users.sourceforge.net, gregkh@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        therbert@google.com
Subject: Re: [PATCH] USB: gadget: fix ethernet gadget crash in gether_setup
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CCEEAEA.4050504@kernel.org>
References: <1288253909-12084-1-git-send-email-mad_soft@inbox.ru>
	<AANLkTi=B93UqfiBFMFryLk1wxus6LwHsSo+8+Ff5D0Ne@mail.gmail.com>
	<4CCEEAEA.4050504@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Kirjanov <dkirjanov@kernel.org>
Date: Mon, 01 Nov 2010 19:29:30 +0300

> [PATCH] USB: gadget: fix ethernet gadget crash in gether_setup
> 
> Crash is triggered by commit e6484930d7 ("net: allocate tx queues in
> register_netdevice"), which moved tx netqueue creation into register_netdev.
> So now calling netif_stop_queue() before register_netdev causes an oops.
> Move netif_stop_queue() after net device registration to fix crash.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>

Applied, thanks.
