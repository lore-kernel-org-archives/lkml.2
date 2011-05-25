Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1EYQxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:53:50 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:49371 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751854Ab1EYQxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:53:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bwahDXFoi52gdvhpYumtfyEJS6VRDYL/mKTTbXSdgpG4DhgZYAR1Wtut1lHNqygrnlMYou4K7YGw9zEMl8Wb5uD2e4ijyRIwaRZD8bxBuVaCKW0OQKcQ3kIoYaOaByeK;
Date: Wed, 25 May 2011 09:53:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Dan Carpenter" <error27@gmail.com>,
        "George Spelvin" <linux@horizon.com>
Subject: Re: [RFC V4] lib: crc8: add new library module providing crc8
 algorithm
Message-Id: <20110525095346.969658ad.rdunlap@xenotime.net>
In-Reply-To: <4DDD3324.3020407@broadcom.com>
References: <1306320099-17970-1-git-send-email-arend@broadcom.com>
	<20110525094304.0769a189.rdunlap@xenotime.net>
	<4DDD3324.3020407@broadcom.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 18:49:40 +0200 Arend van Spriel wrote:

> On 05/25/2011 06:43 PM, Randy Dunlap wrote:
> >
> >> diff --git a/lib/crc8.c b/lib/crc8.c
> >> new file mode 100644
> >> index 0000000..0ce4238
> >> --- /dev/null
> >> +++ b/lib/crc8.c
> >> @@ -0,0 +1,84 @@
> >> +/*
> >> + * Copyright (c) 2011 Broadcom Corporation
> >> + *
> >> + * Permission to use, copy, modify, and/or distribute this software for any
> >> + * purpose with or without fee is hereby granted, provided that the above
> >> + * copyright notice and this permission notice appear in all copies.
> >> + *
> >> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> >> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> >> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
> >> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> >> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> >> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> >> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> >> + */
> > insert blank line here, please.
> 
> Will do that.
> 
> >> +#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
> >> +#include<linux/module.h>
> >> +#include<linux/crc8.h>
> >> +#include<linux/printk.h>
> >> +
> >> +/*
> >> + * crc8_populate_msb - fill crc table for given polynomial in reverse bit order.
> >> + *
> >> + * table:	table to be filled.
> >> + * polynomial:	polynomial for which table is to be filled.
> >> + */
> > Please convert all of these function comments to kernel-doc, like the header file has.
> 
> Can be done easily, but what would be the added value to describe a 
> function twice. I am not fully aware of the usage of kernel-doc, but if 
> it were run over the full kernel tree I would expect the same function 
> to popup twice if I the kernel-doc markup  to the source file as well.

OK, never mind, then.

Usually only one of the files is included in a docbook.tmpl file anyway
(i.e., crc8.h or crc8.c).  Only both would be included if they both contained
something (new/different) to add to the documentation.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
