Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1BMTVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 14:21:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59177
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754606Ab1BMTU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 14:20:57 -0500
Date: Sun, 13 Feb 2011 11:21:32 -0800 (PST)
Message-Id: <20110213.112132.58449746.davem@davemloft.net>
To: jj@chaosbits.net
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, gregkh@suse.de,
        dbrownell@users.sourceforge.net, dhollis@davehollis.com
Subject: Re: [PATCH] USB Network driver infrastructure: Fix leak when
 usb_autopm_get_interface() returns less than zero in kevent().
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1102102152450.26035@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102102152450.26035@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Thu, 10 Feb 2011 21:58:45 +0100 (CET)

> We'll leak the memory allocated to 'urb' in 
> drivers/net/usb/usbnet.c:kevent() when we 'goto fail_lowmem' and the 'urb' 
> variable goes out of scope while still completely unused.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
