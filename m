Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1JWLZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:25:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41136 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1JWLZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:25:36 -0400
MIME-Version: 1.0
In-Reply-To: <4EA3E926.80203@zytor.com>
References: <CALKntY3Xo6R2zLs8oM=+=-VPdFXeLsdGi_YbMiA_1085xhMOQw@mail.gmail.com>
	<CAM_iQpU+xHww_JCYYA4kAKCXmOZpZeu=+rnCyRL-5dW5Uxk1hQ@mail.gmail.com>
	<CALKntY0222DBU88W=j0Y2FpN7NRMSxmDk4XKy-m+keri4Gcu_A@mail.gmail.com>
	<4EA3E926.80203@zytor.com>
Date: Sun, 23 Oct 2011 07:25:35 -0400
Message-ID: <CALKntY0fKv=SmuHxMioN9YDbSz6BJV7xqG4jn5yiLkk+9O8-Jg@mail.gmail.com>
Subject: Re: copy_*_user
From: Xin Tong <xerox.time.tech@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not remember, probably I was under the impression that kernel
accesses physical memory directly from my os course in college. So ,
the kernel access memory using the page table of the current process
here?

Thanks

Xin


On Sun, Oct 23, 2011 at 6:15 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/23/2011 11:23 AM, Xin Tong wrote:
>> I found that __copy_from_user_ll(void *to, const void __user *from,
>> unsigned long n) eventually calls some asm which use mov and rep on
>> the passed-in to & from pointers. This is in kernel mode and to & from
>> are virtual addresses ? are not the kernel accessing physical RAM
>> directly ( without pagetable ) ?
>
> No.  What gave you that idea?
>
>        -hpa
>
>
