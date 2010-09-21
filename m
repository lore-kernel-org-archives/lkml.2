Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0IUQ1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:27:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45184
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756369Ab0IUQ07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:26:59 -0400
Date: Tue, 21 Sep 2010 09:27:18 -0700 (PDT)
Message-Id: <20100921.092718.246552385.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 09/10] jump label 11: add sparc64 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1285083453.23122.1959.camel@gandalf.stny.rr.com>
References: <cover.1284733808.git.jbaron@redhat.com>
	<3b5b071fcdb2afb7f67cacecfa78b14c740278a7.1284733808.git.jbaron@redhat.com>
	<1285083453.23122.1959.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 21 Sep 2010 11:37:33 -0400

> On Fri, 2010-09-17 at 11:09 -0400, Jason Baron wrote:
> 
>> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
>> index 491e9d6..a81b04e 100644
>> --- a/arch/sparc/Kconfig
>> +++ b/arch/sparc/Kconfig
>> @@ -30,6 +30,7 @@ config SPARC
>>  	select PERF_USE_VMALLOC
>>  	select HAVE_DMA_ATTRS
>>  	select HAVE_DMA_API_DEBUG
>> +	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
>>  
> 
> David,
> 
> If you look at the thread for patch #8, do you still want that
>  " if !CC_OPTIMIZE_FOR_SIZE"?

No :-)
