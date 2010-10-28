Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347Ab0J1Rbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:31:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34751
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403Ab0J1Rbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:31:43 -0400
Date: Thu, 28 Oct 2010 10:32:06 -0700 (PDT)
Message-Id: <20101028.103206.28805685.davem@davemloft.net>
To: mad_soft@inbox.ru
Cc: linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net, gregkh@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        therbert@google.com
Subject: Re: [PATCH] USB: gadget: fix ethernet gadget crash in gether_setup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288253909-12084-1-git-send-email-mad_soft@inbox.ru>
References: <1288253909-12084-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Artamonow <mad_soft@inbox.ru>
Date: Thu, 28 Oct 2010 12:18:29 +0400

> Crash is triggered by commit e6484930d7 ("net: allocate tx queues in
> register_netdevice"), which moved tx netqueue creation into register_netdev.
> So now calling netif_stop_queue() before register_netdev causes an oops.
> Move netif_stop_queue() after net device registration to fix crash.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Applied, thank you.
