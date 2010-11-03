Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab0KCRHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:07:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51474 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab0KCRHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=xDeXYssOZFKM0+I+1r+E6zFxt7xn62bKTFnAWdaNHVwB94WYuCs+wXAXxDjQLMSDvO
         q4gtOG4nLFcbVTlZBZa1uVkVDH3bN3pK7tcVhYkmVR1bPz3khbcH4Lo4SJBPXO0nrjHI
         lirCxB/J3h8uBpImsPGnV4xP5A22f8MKUuKqs=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <20101103164840.GC4683@hack>
References: <AANLkTik=04z2thHBS3Z9n68QnTs=i8g8qTFtNT3jb8cg@mail.gmail.com>
	<20101103164840.GC4683@hack>
Date: Wed, 3 Nov 2010 17:07:00 +0000
Message-ID: <AANLkTi=1GdZVYr2z6P7PfR-VKREVzk__1ZodO2nu4dNY@mail.gmail.com>
Subject: Re: Pure kernel '2.6.37-rc1-00001-ge99d11d' shown as ~-dirty after compilation
From: trapDoor <trapdoor6@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 4:48 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, Nov 02, 2010 at 08:26:59AM +0000, trapDoor wrote:
>>,Hello,
>>When I run 'make kernelrelease' on freshly cloned Linus' git tree it
>>shows kernel version as: '2.6.37-rc1-00001-ge99d11d' - and that's
>>correct.
>>But after compilation it turned up '2.6.37-rc1-00001-ge99d11d-dirty'.
>>
>>I didn't apply any custom patches to my local tree between 'make
>>kernelrelease' and compilation. What I only added - and before running
>>'make kernelrelease' - were the following Radeon firmware blobs for my
>>graphic card, which I placed in <kernel-source>/firmware/radeon/, in
>>order to compile them in:
>>REDWOOD_me.bin
>>REDWOOD_pfp.bin
>>REDWOOD_rlc.bin
>>
>>That's how I always did and none of the git-kernels I compiled before
>>was referred to as '-dirty' due to the firmware blobs added manually.
>>Also, the kernel version shown by 'make kernelrelease' never differed
>>from the final kernel version after compilation. Of course assuming
>>that no patches were applied in the meantime and no extra string was
>>appended manually to the kernel version.
>>
>>So, what's this '-dirty' about?
>>
>
> That means your git tree is not clean, since you placed new firmwares
> into the source tree.
>
> --
> Live like a child, think like the god.
>

OK, but then 'make kernelrelease' should produce the same '..-dirty'
version, not just '2.6.37-rc1-00001-ge99d11d', shouldn't it?

I always do the following steps in the same order:
1) first I place the firmware files in <kernel-src>/firmware/radeon
2) then I choose appropriate config file and copy it into kernel
source directory
3) then I run 'make oldconfig' and at the end - just before compiling
and installing - 'make kernelrelease'

As I mentioned, for none of the kernels I compiled prior to this
version (either from git or from tarball) 'make kernelrelease'
produced different version name than it came up after compilation.


-- 
Thanks,
Tomasz
