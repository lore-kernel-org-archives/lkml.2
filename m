Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0ETQsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:48:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61473 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0ETQsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:48:07 -0400
Message-ID: <4BF56827.6070507@colorfullife.com>
Date: Thu, 20 May 2010 18:49:43 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Johannes Stezenbach <js@sig21.net>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [PATCH 1/4] mm: Move ARCH_SLAB_MINALIGN and ARCH_KMALLOC_MINALIGN
 to <linux/slab_def.h>
References: <1274266725.6930.9823.camel@macbook.infradead.org> <1274266902.6930.9834.camel@macbook.infradead.org> <20100519133028.GA26659@sig21.net>  <4BF427D4.40600@colorfullife.com> <1274292638.6930.10394.camel@macbook.infradead.org>
In-Reply-To: <1274292638.6930.10394.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 08:10 PM, David Woodhouse wrote:
>> * Unless debug options are enabled, the kernel uses cache_line_size()
>> automatically.
>>      
> ... that's a lie.
>
>    
You are right, I didn't notice that there are now 8 and 16-byte kmalloc 
caches.

Apart from that:

KMALLOC_FLAGS is SLAB_HWCACHE_ALIGN.
SLAB_HWCACHE_ALIGN defaults the alignment to cache_line_size().


Did I overlook anything else?

--
     Manfred
