Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0EWUoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 16:44:44 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:55026 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0EWUon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 16:44:43 -0400
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request
Date: Sun, 23 May 2010 22:44:41 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.2-gentoo-r1-ck1; KDE/4.4.3; x86_64; ; )
Cc: Borislav Petkov <bp@alien8.de>
References: <201005231829.32106.M4rkusXXL@web.de> <20100523183851.GA20229@liondog.tnic>
In-Reply-To: <20100523183851.GA20229@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005232244.41977.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1/HmQwKWw9G2vg4pFK3QeMYoCc03mvYc/62MvqM
	EUPufs/nTouej5dZDSDW24QfDiVKKyWbu+o5HxcH7Vru+e3EL1
	VLRfkdqAg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It is 0000000001912178.
http://img256.imageshack.us/img256/4370/shotn.gif

Serial console is no option, but this "netconsole"-thing looks 
promising. I'll set that up and try to catch the next one with this.

Thanks, so far

Markus

> From: Markus <M4rkusXXL@web.de>
> Date: Sun, May 23, 2010 at 06:29:32PM +0200
> 
> > Hello!
> > 
> > I have a system running, now its running a 2.6.34 but it also
> > happend with 2.6.33.x and 2.6.32.x.
> > I hit a BUG and the whole system hang. I had to reboot and the
> > console was to small to show the full BUG.
> > But now I got the framebuffer setup and could write the following
> > dump down (by hand, so there might be some typos or so, I have a
> > "screenshot" if you have a specific question)
> > 
> > The system is a amd64 phenom X4 with 2 x 4GB non-ECC RAM and a
> > raid6 for / and a data-partition as well as a raid1 for swap.
> > I ran memtest86+ 4.0 and it showed no errors for two passes.
> > 
> > An hour before that BUG I saw a lot of async-processes.
> > It happens round about once a day, will check if its the same or
> > similar the next time.
> > 
> > But any hints are greatly appreciated! (How to solve or how to get
> > needed informations.)
> > 
> > Thanks,
> > Markus
> > 
> > PS: Please CC me.
> > 
> > 
> > [64112.493940] BUG: unable to handle kernel paging request at
> > 0000000001912178
> 
> Ok, I'm looking at that oops and am trying to follow what happens but
> in order for all to fit the 0000000001912178 value above should
> actually be 0000000001912a78, if I'm not mistaken.
> 
> Can you please check if that's the case or send me that screenshot
> you mention above. Better yet, can you catch that oops over a serial
> console or a netconsole or similar?
> 
> Thanks.

