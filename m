Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab0G0EFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 00:05:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44794
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab0G0EFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 00:05:05 -0400
Date: Mon, 26 Jul 2010 21:05:22 -0700 (PDT)
Message-Id: <20100726.210522.191412048.davem@davemloft.net>
To: segooon@gmail.com
Cc: kernel-janitors@vger.kernel.org, dbrownell@users.sourceforge.net,
        gregkh@suse.de, ben@decadent.org.uk, joe@perches.com,
        shemminger@vyatta.com, jussi.kivilinna@mbnet.fi,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet: use jiffies in schedule_timeout(), not msecs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1280132742-8126-1-git-send-email-segooon@gmail.com>
References: <1280132742-8126-1-git-send-email-segooon@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>
Date: Mon, 26 Jul 2010 12:25:42 +0400

> usbnet_terminate_urbs() uses schedule_timeout() with argument 3 msecs.
> schedule_timeout() uses jiffies as argument, so convert msecs to jiffies
> with msecs_to_jiffies().
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Applied, thanks.
