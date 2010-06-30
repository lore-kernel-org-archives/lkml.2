Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab0F3UG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:06:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57160
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757241Ab0F3UGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:06:55 -0400
Date: Wed, 30 Jun 2010 13:07:09 -0700 (PDT)
Message-Id: <20100630.130709.93452021.davem@davemloft.net>
To: joe@perches.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 0/4] Introduce and use printk pointer extension %pV
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1277636090.git.joe@perches.com>
References: <cover.1277636090.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 27 Jun 2010 04:02:32 -0700

> Recursive printk can reduce the total image size of an x86 defconfig about 1% 
> by reducing duplicated KERN_<level> strings and centralizing the functions
> used by macros in new separate functions.
> 
> Joe Perches (4):
>   vsprintf: Recursive vsnprintf: Add "%pV", struct va_format
>   device.h drivers/base/core.c Convert dev_<level> logging macros to functions
>   netdevice.h net/core/dev.c: Convert netdev_<level> logging macros to functions
>   netdevice.h: Change netif_<level> macros to call netdev_<level> functions

I'm fine with this, thanks Joe.

Greg, could you ACK this and let me know if it's OK if it swings
through my net-next-2.6 tree?

Thanks.
