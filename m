Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab1EYQt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:49:57 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2539 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998Ab1EYQtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:49:55 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4DDD3324.3020407@broadcom.com>
Date: Wed, 25 May 2011 18:49:40 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Randy Dunlap" <rdunlap@xenotime.net>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Dan Carpenter" <error27@gmail.com>,
        "George Spelvin" <linux@horizon.com>
Subject: Re: [RFC V4] lib: crc8: add new library module providing crc8
 algorithm
References: <1306320099-17970-1-git-send-email-arend@broadcom.com>
 <20110525094304.0769a189.rdunlap@xenotime.net>
In-Reply-To: <20110525094304.0769a189.rdunlap@xenotime.net>
X-WSS-ID: 61C3EB8D4NS11894002-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 06:43 PM, Randy Dunlap wrote:
>
>> diff --git a/lib/crc8.c b/lib/crc8.c
>> new file mode 100644
>> index 0000000..0ce4238
>> --- /dev/null
>> +++ b/lib/crc8.c
>> @@ -0,0 +1,84 @@
>> +/*
>> + * Copyright (c) 2011 Broadcom Corporation
>> + *
>> + * Permission to use, copy, modify, and/or distribute this software for any
>> + * purpose with or without fee is hereby granted, provided that the above
>> + * copyright notice and this permission notice appear in all copies.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
>> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
>> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
>> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
>> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
> insert blank line here, please.

Will do that.

>> +#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
>> +#include<linux/module.h>
>> +#include<linux/crc8.h>
>> +#include<linux/printk.h>
>> +
>> +/*
>> + * crc8_populate_msb - fill crc table for given polynomial in reverse bit order.
>> + *
>> + * table:	table to be filled.
>> + * polynomial:	polynomial for which table is to be filled.
>> + */
> Please convert all of these function comments to kernel-doc, like the header file has.

Can be done easily, but what would be the added value to describe a 
function twice. I am not fully aware of the usage of kernel-doc, but if 
it were run over the full kernel tree I would expect the same function 
to popup twice if I the kernel-doc markup  to the source file as well.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


