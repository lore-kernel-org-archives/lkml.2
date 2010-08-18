Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab0HRFr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:47:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40191
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793Ab0HRFrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:47:53 -0400
Date: Tue, 17 Aug 2010 22:48:12 -0700 (PDT)
Message-Id: <20100817.224812.226786243.davem@davemloft.net>
To: sam@ravnborg.org
Cc: benh@kernel.crashing.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulus@au.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: 64-bit ppc rwsem
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100818053955.GA11962@merkur.ravnborg.org>
References: <1282107803.22370.173.camel@pasglop>
	<20100817.222818.193699062.davem@davemloft.net>
	<20100818053955.GA11962@merkur.ravnborg.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 18 Aug 2010 07:39:55 +0200

>> @@ -15,7 +15,7 @@ lib-$(CONFIG_SPARC32) += divdi3.o udivdi3.o
>>  lib-$(CONFIG_SPARC32) += copy_user.o locks.o
>>  lib-y                 += atomic_$(BITS).o
>>  lib-$(CONFIG_SPARC32) += lshrdi3.o ashldi3.o
>> -lib-y                 += rwsem_$(BITS).o
>> +lib-$(CONFIG_SPARC32) += rwsem_$(BITS).o
> 
> You could write this explicit as:
> 
>> +lib-$(CONFIG_SPARC32) += rwsem_32.o
> 
> As rwsem_64 is gone now.

Sure, I'll make that change, thanks Sam.
