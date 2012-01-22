Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab2AVPnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 10:43:06 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39499 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2AVPnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 10:43:04 -0500
Message-ID: <4F1C2E7F.1000902@gmail.com>
Date: Sun, 22 Jan 2012 17:42:55 +0200
From: Mantas <grawity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.suspend.devel,gmane.linux.kernel
To: Srivatsa Bhat <srivatsasbhat@gmail.com>
CC: maciej.rutecki@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        suspend-devel@lists.sourceforge.net,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: 3.2-git - freeze during hibernation
References: <jepbo0$l1e$1@dough.gmane.org> <201201220905.10710.maciej.rutecki@gmail.com> <CAE368AS+FjoTvtBT0A2Qa0RXrJYbgxNdv6OOvD3cnmsTrLsRyQ@mail.gmail.com>
In-Reply-To: <CAE368AS+FjoTvtBT0A2Qa0RXrJYbgxNdv6OOvD3cnmsTrLsRyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-22 10:32, Srivatsa Bhat wrote:
> On Sun, Jan 22, 2012 at 1:35 PM, Maciej Rutecki
> <maciej.rutecki@gmail.com <mailto:maciej.rutecki@gmail.com>> wrote:
> 
>     (Add CC to Rafael)
> 
>     On piątek, 13 stycznia 2012 o 14:31:44 Mantas wrote:
>     > Using uswsusp git-17789a0 and Linux git-v3.2-6540-g4c4d285, suspend to
>     > disk freezes right before writing the memory to disk -- "Saving X
>     image
>     > data pages" appears, but the percentage does not, nor is there any
>     disk
>     > activity; all I can do is reboot using Alt+SysRq.
>     >
>     > Same version of uswsusp, both suspend to memory and disk, worked
>     > perfectly with Linux v3.2 release and earlier versions. The device is
>     > ASUS K52JT. Any hints?
> 
> 
> Hi,
> 
> Could you please try the patch posted at:
> https://lkml.org/lkml/2012/1/19/177 ?

It does fix this particular issue; the suspend image is written correctly.

However, now it hangs at the "Suspending consoles" message -- sometimes
before writing image, sometimes after...

I will try the same patch against latest linux-git and see if there are
any changes.

-- 
Mantas M.
