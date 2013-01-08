Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3AHWZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:25:21 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:41712 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3AHWZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:25:18 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyEE6pM2gVfgd3xjQR5rF6ij5pG7BXjkH+C5aHbxAk6mg@mail.gmail.com>
References: <CAAJw_Zv8O1LPX-jmpg3fvNrWMLWbQC=1tbZ6T7nsm6cyC008fg@mail.gmail.com>
	<CA+55aFxXAMz5Sg44e-TJ0P=LY+3VkfdNtZMS3EJEHdztY2kC0Q@mail.gmail.com>
	<CAAJw_ZtpubRhSF3K=B91oHXMPaTX6jGNLZn+e6ks83JS92k=bw@mail.gmail.com>
	<CA+55aFyEE6pM2gVfgd3xjQR5rF6ij5pG7BXjkH+C5aHbxAk6mg@mail.gmail.com>
Date: Wed, 9 Jan 2013 06:25:17 +0800
Message-ID: <CAAJw_ZseBZZkv3W-ec_bLLMmpLLAyJx4KMvE0z=drQZH4L5yKA@mail.gmail.com>
Subject: Re: 2nd attempt: help with dma_alloc_coherent() + dma_free_coherent()
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 1:24 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jan 8, 2013 at 9:17 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>>
>> Interesting, but there are 54 lines under the kernel directories that
>> use "dma_alloc_coherent(NULL," followed by "dma_free_coherent(NULL,"
>
> As mentioned, it works on some platforms. That doesn't make it right.
>
>> So, shouldn't they be fixed as well? ... unless they are so old that
>> nobody cares anymore ...
>
> Some of the ones I saw are in MIPS or blackfin. Others probably *are*
> so old that nobody cares, and happen to work because there's iommu's
> or other things that simply don't care about the device.
>
>> # find . -exec grep -H "dma_alloc_coherent(NULL" {} \; | wc -l
>> 54
>>
>> #find . -exec grep -H "dma_free_coherent(NULL" {} \; | wc -l
>> 72
>
> Let me tell you about "git grep", so that you never need to do that
> disgusting "find -exec grep" ever again.
>
> It does threading, it's fast, and it just works.
>
>                 Linus

Yes, "git grep" is really fast. Cool! ... didn't know that before.

Thanks again for the help.

Jeff.
