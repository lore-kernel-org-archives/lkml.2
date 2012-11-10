Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab2KJAyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:54:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39709 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2KJAyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:54:19 -0500
Date: Fri, 09 Nov 2012 19:54:17 -0500 (EST)
Message-Id: <20121109.195417.1781257873335425911.davem@davemloft.net>
To: shuah.khan@hp.com
Cc: kyungmin.park@samsung.com, arnd@arndb.de, m.szyprowski@samsung.com,
        sam@ravnborg.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH RFT RESEND linux-next] sparc: dma-mapping: support
 debug_dma_mapping_error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352508743.5524.41.camel@lorien2>
References: <1351267989.4013.20.camel@lorien2>
	<20121109.193849.458704479891559672.davem@davemloft.net>
	<1352508743.5524.41.camel@lorien2>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shuah Khan <shuah.khan@hp.com>
Date: Fri, 09 Nov 2012 17:52:23 -0700

> On Fri, 2012-11-09 at 19:38 -0500, David Miller wrote:
>> From: Shuah Khan <shuah.khan@hp.com>
>> Date: Fri, 26 Oct 2012 10:13:09 -0600
>> 
>> > Add support for debug_dma_mapping_error() call to avoid warning from
>> > debug_dma_unmap() interface when it checks for mapping error checked
>> > status. Without this patch, device driver failed to check map error
>> > warning is generated.
>> > 
>> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
>> 
>> This doesn't even compile:
>> 
>> /home/davem/src/GIT/sparc/arch/sparc/include/asm/dma-mapping.h: In function 'dma_mapping_error':
>> /home/davem/src/GIT/sparc/arch/sparc/include/asm/dma-mapping.h:62:2: error: implicit declaration of function 'debug_dma
>> _mapping_error' [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>> In file included from include/linux/dma-mapping.h:76:0,
>>                  from include/linux/skbuff.h:33,
>>                  from include/linux/icmpv6.h:4,
>>                  from include/linux/ipv6.h:58,
>>                  from include/net/ipv6.h:16,
>>                  from include/linux/sunrpc/clnt.h:26,
>>                  from include/linux/nfs_fs.h:30,
>>                  from init/do_mounts.c:30:
> 
> The problem the dependent patch is in linux-next and not in arch trees
> yet. That is why I am trying it get this through linux-next and/or
> dma-debug tree. I am open to suggestions on what is the best route.

Then please put this in via the dma-debug tree:

Acked-by: David S. Miller <davem@davemloft.net>
