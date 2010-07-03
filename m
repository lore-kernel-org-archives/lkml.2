Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0GCFcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 01:32:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40949
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab0GCFcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 01:32:31 -0400
Date: Fri, 02 Jul 2010 22:32:44 -0700 (PDT)
Message-Id: <20100702.223244.193707555.davem@davemloft.net>
To: joe@perches.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 0/4] Introduce and use printk pointer extension %pV
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100630.130709.93452021.davem@davemloft.net>
References: <cover.1277636090.git.joe@perches.com>
	<20100630.130709.93452021.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 30 Jun 2010 13:07:09 -0700 (PDT)

> From: Joe Perches <joe@perches.com>
> Date: Sun, 27 Jun 2010 04:02:32 -0700
> 
>> Recursive printk can reduce the total image size of an x86 defconfig about 1% 
>> by reducing duplicated KERN_<level> strings and centralizing the functions
>> used by macros in new separate functions.
>> 
>> Joe Perches (4):
>>   vsprintf: Recursive vsnprintf: Add "%pV", struct va_format
>>   device.h drivers/base/core.c Convert dev_<level> logging macros to functions
>>   netdevice.h net/core/dev.c: Convert netdev_<level> logging macros to functions
>>   netdevice.h: Change netif_<level> macros to call netdev_<level> functions
> 
> I'm fine with this, thanks Joe.
> 
> Greg, could you ACK this and let me know if it's OK if it swings
> through my net-next-2.6 tree?

Greg, ping?
