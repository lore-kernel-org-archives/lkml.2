Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab2GIVlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:41:08 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:39672 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753967Ab2GIVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:41:06 -0400
Message-ID: <4FFB4FC6.7020509@xenotime.net>
Date: Mon, 09 Jul 2012 14:40:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for July 2 (crypto/hifn_795x)
References: <20120702172334.2618cae84cc57b4ec5a63ed7@canb.auug.org.au> <4FF1CBF2.8060303@xenotime.net> <20120709205441.11422bntesq3cdno@www.81.fi>
In-Reply-To: <20120709205441.11422bntesq3cdno@www.81.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 10:54 AM, Jussi Kivilinna wrote:

> Quoting Randy Dunlap <rdunlap@xenotime.net>:
> 
>> On 07/02/2012 12:23 AM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120629:
>>>
>>
>>
>> on i386:
>>
>>
>> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
>>
> 
> This is caused by commit feb7b7ab928afa97a79a9c424e4e0691f49d63be. hifn_795x has "DIV_ROUND_UP(NSEC_PER_SEC, dev->pk_clk_freq)", which should be changed to DIV_ROUND_UP_ULL now that NSEC_PER_SEC is 64bit on 32bit archs. Patch to fix hifn_795x is attached (only compile tested).



Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


-- 
~Randy
