Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab2LJLG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:06:28 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:34948 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2LJLG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:06:27 -0500
From: Lekensteyn <lekensteyn@gmail.com>
To: M Z <magez.magez@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc8 regression] Buffer I/O error on device sda during boot (attempt to access beyond end of device)
Date: Mon, 10 Dec 2012 12:06:08 +0100
Message-ID: <20226716.3fCgHS08dt@al>
User-Agent: KMail/4.9.4 (Linux/3.7.0-1-custom; KDE/4.9.4; x86_64; ; )
In-Reply-To: <CADhePA2UTjvTmJOVnW_gNXmQ_T=Rk28HAf2pHqKj4akyp7+V9A@mail.gmail.com>
References: <CADhePA2UTjvTmJOVnW_gNXmQ_T=Rk28HAf2pHqKj4akyp7+V9A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 10 December 2012 11:42:22 M Z wrote:
> booting vanilla  3.7-rc8 kernel on Acer Aspire 1810TZ yields these
> errors (I was using 3.6.9-1 and 3.5.5-1 from Debian experimental
> before without these errors)
> 
>  [    9.265058] attempt to access beyond end of device
<snip>
>  [    9.265389] Buffer I/O error on device sda1, logical block 121047812
> 
> 
> Any idea before I hit the bisect route? (should I worry about these errors? 
> )

This error immediately showed up when testing 3.7-rc8 and is discussed/patched 
already on https://lkml.org/lkml/2012/12/3/497. 

To cite from https://lkml.org/lkml/2012/12/3/510:
> Anyway, to clarify: the printk's are harmless, since the IO past the
> end of the device is just error'ed out, and always has been.  Which is
> why I was considering just removing them.

Regards,
Peter
