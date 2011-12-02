Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab1LBSYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:24:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34008 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1LBSYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:24:19 -0500
MIME-Version: 1.0
In-Reply-To: <4ED88A78.8010706@suse.cz>
References: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
	<1321457231-9154-2-git-send-email-jslaby@suse.cz>
	<CA+8MBbJ4Tu86jSbaBRjDKfowwVE12jY3efK7QMm74e7i8aq4Hg@mail.gmail.com>
	<4ED88A78.8010706@suse.cz>
Date: Fri, 2 Dec 2011 10:24:18 -0800
Message-ID: <CA+8MBb+ju0ECRKmV6d0mGEBHsfWeyD3k3UAyZFodTAGwsBDLug@mail.gmail.com>
Subject: Re: [PATCH 2/5] TTY: ldisc, move wait idle to caller
From: Tony Luck <tony.luck@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Dave Young <hidave.darkstar@gmail.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitriy Matrosov <sgf.dma@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, stable <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 2, 2011 at 12:21 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> Thanks. What distro and init do you use? Does the attached patch help?

Patch didn't apply cleanly ... it looks like you have another patch that
deleted these lines:
        if (ret < 0)
                return ret;
from tty_ldisc_wait_idle() ... so I think I hand applied around this by dropping
those lines too - but I might have goofed.

Anyway - the patch as modified by me didn't work. I still see the hang.

Base distro is SLES11-SP1
Init version: sysvinit-2.86-198.20

System is headless (no graphic card) so serial console is all I have.

ia64 early serial console is enabled with boot argument:
console=uart,mmio,0xff5e0000

-Tony
