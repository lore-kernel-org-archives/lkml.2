Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab2DJSSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:18:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47161 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2DJSSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAMOZ1Bv49XM-f7DEan8fEbDAb3VJf28uOqdKWYJH4tdQ7CvH6g@mail.gmail.com>
References: <1334081054.1431.23.camel@localhost.localdomain> <CAMOZ1Bv49XM-f7DEan8fEbDAb3VJf28uOqdKWYJH4tdQ7CvH6g@mail.gmail.com>
From: Michael Witten <mfwitten@gmail.com>
Date: Tue, 10 Apr 2012 18:18:22 +0000
Message-ID: <CAMOZ1BsENapdSsiaQj9Yo9aUUx0J5_kyHaz7kVTmq+MNAXhj-Q@mail.gmail.com>
Subject: Re: How to skip the initramfs?
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 18:14, Michael Witten <mfwitten@gmail.com> wrote:
> On Tue, Apr 10, 2012 at 18:04, Thomas Meyer <thomas@m3y3r.de> wrote:
>> How to skip the execution of the initramfs? option "noinitrd" doesn't
>> seem to work on 3.0 kernel.
>>
>> Or is there an option to build an abootimg without initramfs? I didn't
>> find one.
>>
>> with kind regards
>> thomas
>
> I have always built my kernel without support for initramfs/initrd
> by setting the build configuration variable `CONFIG_BLK_DEV_INITRD'
> to `n'; in a Kconfig set up UI, you can find this option under
> `General setup' as the item:
>
>  Initial RAM filesystem and RAM disk (initramfs/initrd) support
>
> You should probably also tell your boot loader (such as `grub') not
> to bother loading an initial ram disk.
>
> However, I have the vague notion that there have been rumblings about
> requiring initramfs/initrd support in the future; does anybody know if
> this is true?

I should also add that if you do this, it is imperative that you build
into the kernel all of the necessary drivers for completing the boot
process.
