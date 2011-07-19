Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab1GSTn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:43:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51235 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSTnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:43:55 -0400
MIME-Version: 1.0
In-Reply-To: <201107191953.12923.arnd@arndb.de>
References: <CAOMGZ=HS2EPkYD=5HfkSPpwPqHB5V3q0vaFmoZ8Hh+pMM9phrQ@mail.gmail.com>
	<201107191953.12923.arnd@arndb.de>
Date: Tue, 19 Jul 2011 21:43:54 +0200
Message-ID: <CAOMGZ=GrBLL+EgtG1ZGNquMVNxD=X01vd3sakr7ZKFEh9m7xPA@mail.gmail.com>
Subject: Re: WARNING: at drivers/tty/tty_ldisc.c:766 tty_ldisc_reinit+0x7d/0x90()
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 July 2011 19:53, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 19 July 2011 13:33:36 Vegard Nossum wrote:
>> Any ideas?
>
> This is the WARN_ON that Jiri added in 92f6fa09b "TTY: ldisc, do not close
> until there are readers".
>
> Is the login process that triggered this running on the USB device you pass
> through, or do you have vga or serial console?

I am using console=ttyS0 console=tty0, so I have both vga and serial
console. The login process was running on the vga console.


Vegard
