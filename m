Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0GIM41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 08:56:27 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58775 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab0GIM4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 08:56:25 -0400
Message-ID: <4C371C78.1010701@kernel.dk>
Date: Fri, 09 Jul 2010 14:56:24 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (block
 tree related)
References: <20100709143940.f0f06690.sfr@canb.auug.org.au> <201007091454.09011.arnd@arndb.de>
In-Reply-To: <201007091454.09011.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-09 14:54, Arnd Bergmann wrote:
> On Friday 09 July 2010, Stephen Rothwell wrote:
> 
>> I applied the following patch for today:
>>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Fri, 9 Jul 2010 14:24:38 +1000
>> Subject: [PATCH] block: fix for block tracing build error
>>
>> block/compat_ioctl.c: In function 'compat_blkdev_ioctl':
>> block/compat_ioctl.c:754: error: 'BLKTRACESETUP32' undeclared (first use in this function)
> 
> Yes, the fix looks right, sorry about the breakage.
> I only tested with CONFIG_BLOCK_TRACE enabled, so I did not
> catch this.
> 
> Jens, please apply Stephen's patch.

Added, thanks Stephen.

-- 
Jens Axboe

