Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1ILGU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 02:20:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43970 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1ILGU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 02:20:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9NwWfGA7jLWDZcN=DfGN5H2g=dt6U8SBxAX_wJAk6MKKfZAA@mail.gmail.com>
References: <CAH9NwWfGA7jLWDZcN=DfGN5H2g=dt6U8SBxAX_wJAk6MKKfZAA@mail.gmail.com>
Date: Mon, 12 Sep 2011 07:20:25 +0100
Message-ID: <CAAMvbhETfkdvD7oro4bHcu1szwZn=uUc3TC+e3PmTrf=pZxjrg@mail.gmail.com>
Subject: Re: Linux as Bootloader
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2011 09:24, Christian Gmeiner
<christian.gmeiner@gmail.com> wrote:
> Hi all,
>
> I am using the linux kernel in combination with busybox and a separate
> bootloader app to
> startup a x86 based embedded device. As the used BIOS does only do
> basic hw init, we
> used Linux as a bootloader. Our custom BIOS starts the bootloader
> kernel located in BIOS
> flash. If the kernel and userland is ready our boot application
> searches for the productive kernel
> and executes it via kexec.
>
> Now I run in some troubles as I need to be able to boot a MSDOS
> application stored on
> an usb stick. I have tried grub4linux but I am not able to boot from
> the usb stick - even I
> see the grub command line.
>
> Are there some creative/working solutions for my problem?
>

To get DOS running, it relies on a PC BIOS. You don't have one.
Either implement a PC BIOS or run the dos app using dosbox, dosemu or kvm.
Just out of curiosity, what does the DOS app do?
There might be a reason why running it in dosbox, dosemu, or kvm might not work.
