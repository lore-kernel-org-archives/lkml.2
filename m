Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1ESEfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 00:35:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51075 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab1ESEfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 00:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BFR6Y33Zl6ggwKh6hSCm3Q24YuGTDjscKWLuG1zc3EC6HP09habJ2nx34xq7/2F6Zq
         HxEwQxrf1LqkpugQhR0I4KTR1sj6+IRFkRxB7md2mCu2N+YoA4Ku8pwXMZo2y117aAqW
         /4b8LA9O4l4VYK57JyRV2L9hc3sxAACMwGNgI=
MIME-Version: 1.0
In-Reply-To: <AANLkTimy6FPdgW=f8HOTBd6ORKmjvX3KFONXesacJ6Ms@mail.gmail.com>
References: <AANLkTimkh2QLvupu+62NGrKfqRb_gC7KLCAKkEoS9N9N@mail.gmail.com>
	<20110325172709.GC8483@linux-mips.org>
	<AANLkTimy6FPdgW=f8HOTBd6ORKmjvX3KFONXesacJ6Ms@mail.gmail.com>
Date: Thu, 19 May 2011 10:05:45 +0530
Message-ID: <BANLkTimysdkBnr0LEdOsiT+Z3O-w-KO7=g@mail.gmail.com>
Subject: Re: flush_kernel_vmap_range() invalidate_kernel_vmap_range() API not
 exists for MIPS
From: naveen yadav <yad.naveen@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

Have you got time to look into this issue.

Regards


On Tue, Mar 29, 2011 at 11:24 AM, naveen yadav <yad.naveen@gmail.com> wrote:
> I am sorry, Yes they are VIPT,
>
>
> On Fri, Mar 25, 2011 at 10:57 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
>> On Fri, Mar 25, 2011 at 02:38:13PM +0530, naveen yadav wrote:
>>
>>> We are working on 2.6.35.9 linux kernel on MIPS 34kce core and our
>>> cache is VIVT having cache aliasing .
>>
>> No, they're VIPT unless you successfully modified your 34K core to
>> change it from a less than perfect cache design to the most lunatic
>> cache policy known to man kind ...
>>
>>> When I check the implementation on ARM I can check the implemenation
>>> exists , but there is not similar implementation exists on MIPS.
>>> These API's are used by XFS module:
>>>
>>> static inline void flush_kernel_vmap_range(void *vaddr, int size)
>>> static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
>>> static inline void flush_kernel_dcache_page(struct page *page)
>>
>> A known problem for (too ...) long.  I'll finally take care of it.
>>
>>  Ralf
>>
>
