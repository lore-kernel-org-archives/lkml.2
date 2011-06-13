Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1FMXR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:17:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661Ab1FMXR1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:17:27 -0400
MIME-Version: 1.0
In-Reply-To: <web-546810453@zbackend1.aha.ru>
References: <web-546810453@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Jun 2011 16:17:04 -0700
Message-ID: <BANLkTimTjcXPfiPDvyMEgRCH0EA2E9mMpQ@mail.gmail.com>
Subject: Re: problems with mtp , better to make a command-line option to can
 switch off mtp device search on booting
To: werner <w.landgraf@ru.ru>, David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I still think you're crazy to compile in MTD support at all, but
hey, I do agree that it is supposed to work.

The "L440GX flash mapping failed" message isn't new, and I doubt that
that particular driver is the problem. Can you try to narrow it down
to _which_ MTD driver causes problems? Enable MTD again, and try to
enable about half the devices to "bisect" the issue.

                       Linus

On Mon, Jun 13, 2011 at 4:06 PM, werner <w.landgraf@ru.ru> wrote:
> I get yesterday an acer laptop with big problems to install Linux
>
> booting stopped with error messages like:
>
> physmap_flash.0 failed claim ressource 0
>
> L440GX flash mapping failed to find PIIX4 ISA bridge, cannot continue
>
> Then the computer stopped, but not crashed, the cursor stopped to blink, but
> reboot
> with CTRL-ALT-DEL didn't work, one had to press the reboot button
>
> I recompiled the kernel with all MTP things switched off, and that booted.
>
> However, normally it should be compiled everything in the kernel, and the
> kernel
> during booting should manage it to see and to use what is existent in the
> computer
> of the user, without to stick or to crash.
>
> Probably that is an error already sine time in the kernel, not a recent
> regression.
>
> Better to make a command-line option to can switch off mtp device search on
> booting
>
> wl
>
>
> =================================================
> I have problems to post something from my home computer site šguyane.yi.org
> or SYS-Linux.yi.org :
>
> Deferred: 451 4.7.1 Hello [93.121.138.180], for recipient address the policy
> analysis reported: Greylisted, see
> http://isg.ee.ethz.ch/tools/postgrey/help/vger.kernel.org.html
> ---
> Professional hosting for everyone - http://www.host.ru
>
