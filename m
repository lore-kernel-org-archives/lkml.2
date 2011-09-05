Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab1IEIYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 04:24:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59322 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1IEIYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 04:24:34 -0400
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 5 Sep 2011 10:24:13 +0200
Message-ID: <CAH9NwWfGA7jLWDZcN=DfGN5H2g=dt6U8SBxAX_wJAk6MKKfZAA@mail.gmail.com>
Subject: Linux as Bootloader
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am using the linux kernel in combination with busybox and a separate
bootloader app to
startup a x86 based embedded device. As the used BIOS does only do
basic hw init, we
used Linux as a bootloader. Our custom BIOS starts the bootloader
kernel located in BIOS
flash. If the kernel and userland is ready our boot application
searches for the productive kernel
and executes it via kexec.

Now I run in some troubles as I need to be able to boot a MSDOS
application stored on
an usb stick. I have tried grub4linux but I am not able to boot from
the usb stick - even I
see the grub command line.

Are there some creative/working solutions for my problem?

thanks
--
Christian Gmeiner, MSc
