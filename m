Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1BNTYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:24:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52098
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638Ab1BNTYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:24:45 -0500
Date: Mon, 14 Feb 2011 11:25:21 -0800 (PST)
Message-Id: <20110214.112521.104056910.davem@davemloft.net>
To: segoon@openwall.com
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        therbert@google.com, xiaosuo@gmail.com, jesse@nicira.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] core: dev: don't call BUG() on bad input
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110214152310.GA24429@albatros>
References: <1297694579-23611-1-git-send-email-segoon@openwall.com>
	<AANLkTimidxVJxw-XKTWwCZh8k_vKHDeqxAwVbY6+aJ6x@mail.gmail.com>
	<20110214152310.GA24429@albatros>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>
Date: Mon, 14 Feb 2011 18:23:10 +0300

> On Mon, Feb 14, 2011 at 17:16 +0200, Alexey Dobriyan wrote:
>> Netdevice name isn't some random junk you get from userspace, so BUG is fine.
> 
> It IS for bluetooth, see net/bluetooth/bnep/core.c: bnep_add_connection() and
> net/bluetooth/bnep/sock.c: bnep_sock_ioctl(). 

If bluetooth wants to allow something so foolish, then it's bluetooth's
responsibility to sanity check the arguments before blinding passing
them into kernel APIs which expect sane inputs.

I'm not applying this.
