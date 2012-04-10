Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab2DJSPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:15:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47662 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab2DJSPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:15:21 -0400
MIME-Version: 1.0
In-Reply-To: <1334081054.1431.23.camel@localhost.localdomain>
References: <1334081054.1431.23.camel@localhost.localdomain>
From: Michael Witten <mfwitten@gmail.com>
Date: Tue, 10 Apr 2012 18:14:50 +0000
Message-ID: <CAMOZ1Bv49XM-f7DEan8fEbDAb3VJf28uOqdKWYJH4tdQ7CvH6g@mail.gmail.com>
Subject: Re: How to skip the initramfs?
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 18:04, Thomas Meyer <thomas@m3y3r.de> wrote:
> How to skip the execution of the initramfs? option "noinitrd" doesn't
> seem to work on 3.0 kernel.
>
> Or is there an option to build an abootimg without initramfs? I didn't
> find one.
>
> with kind regards
> thomas

I have always built my kernel without support for initramfs/initrd
by setting the build configuration variable `CONFIG_BLK_DEV_INITRD'
to `n'; in a Kconfig set up UI, you can find this option under
`General setup' as the item:

  Initial RAM filesystem and RAM disk (initramfs/initrd) support

You should probably also tell your boot loader (such as `grub') not
to bother loading an initial ram disk.

However, I have the vague notion that there have been rumblings about
requiring initramfs/initrd support in the future; does anybody know if
this is true?

Sincerely,
Michael Witten
