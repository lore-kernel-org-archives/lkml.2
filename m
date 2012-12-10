Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2LJOtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:49:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39025 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2LJOtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:49:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ-WASdGwab0ep_O5YxsfFP+3ivtqoj4XQ7vsGwZwANTP25mzQ@mail.gmail.com>
References: <CANFwon0-QQygKUmRq6E3QawbFqkPc1zy2Om2E7qvCXB-LZdbFQ@mail.gmail.com>
 <CAJ-WASdGwab0ep_O5YxsfFP+3ivtqoj4XQ7vsGwZwANTP25mzQ@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 10 Dec 2012 22:48:40 +0800
Message-ID: <CANFwon1D4nO5U5gon3oVor-3D=He0N2vZojgT9tfz3ArH0W3sg@mail.gmail.com>
Subject: Re: KGTP (Linux debugger and tracer) 20121204 release (bug fix and
 doc update)
To: Pawel Suchanecki <subdcc@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 7:51 PM, Pawel Suchanecki <subdcc@gmail.com> wrote:
> 2012/12/10 Hui Zhu <teawater@gmail.com>
>>
>> According to the comments of Christoph, Geoff and Andi.  I make lite
>> patch for review.  Please goto https://lkml.org/lkml/2012/5/9/90 to
>> see it.
>
> The patch you sent for review used kmalloc/memset() combo but in your
> SVN (the tag specified (20121204) and in trunk as well) it was already
> converted to kcalloc().
>
> However it looks like you could reduce kernel text by using kzalloc()
> instead of kcalloc(1, ...) (everywhere you allocate just one entry).
>
> This issue was described here: http://lwn.net/Articles/147014/.
>
> Thanks,
> Pawel

Thanks.  I will update them later.

Best,
Hui

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
