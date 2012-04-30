Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2D3JAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:00:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab2D3JAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:00:37 -0400
From: Steffen =?ISO-8859-1?Q?M=FCller?= <steffen.mueller@radio-frei.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: opensuse-factory@opensuse.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>, stable@kernel.org,
        Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [opensuse-factory] Re: usb midi keyboard broken [3.3.3 regression] [SOLUTION]
Date: Mon, 30 Apr 2012 11:00:05 +0200
Message-ID: <2197151.1tZV6ssZos@thinkpadsm.rf-studio>
User-Agent: KMail/4.8.2 (Linux/3.3.3-21-desktop-steffen; KDE/4.8.2; x86_64; ; )
In-Reply-To: <201204301048.21852.oliver@neukum.org>
References: <Pine.LNX.4.44L0.1204271122550.1690-100000@iolanthe.rowland.org> <5861865.YnqskICckP@thinkpadsm.rf-studio> <201204301048.21852.oliver@neukum.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:vj7JXroxIggnds/X5sbxIf92x4rmHLIfHa3Z7QICg+t
 GBNEwxwXqRKXhHplBeSD8+d6HKuC95xt3f2cAJQ3U2O0ZVEsAT
 Y6Y7ZAV6pgEsVlboiHN24doVc1uJcQuX1CcQPl/aT9ZmG7yD/f
 VcUDI1r10Sh4AKP6FAzu6xEu0PwKr/j9gtJ3tOnx+us0SSBvLY
 KO9ERuauc7zuxryyteOIS5wV+wsDc1w4jMynTgm9jiVMbKSn8U
 497BOHHMiWzlnR9j6iL3qr8Pm7qmHxSZ5LlHHhzLakOT8LyLkK
 nxFu3/9AUUq7MYtVgpLiq4BPN5nxID8AYO7TJdNPe0MkW5EgSq
 6KQM6X/+g0w/5NXuT/L3jOVMGgrsgdmOGmoXYN8BtiTKVV15jO
 pvClDoiihvhDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 30. April 2012, 10:48:21 schrieb Oliver Neukum:
> Am Samstag, 28. April 2012, 23:26:58 schrieb Steffen Müller:
> > yes, it works now without blacklisting for autosuspend after build patched
> > kernel with this in drivers/usb/core/quirks.c
> > 
> > rf@ThinkpadSM:~/tmp> diff -uNr quirks-org.c quirks.c
> > --- quirks-org.c        2012-04-28 23:19:45.440959001 +0200
> > +++ quirks.c    2012-04-28 20:38:50.000000000 +0200
> > @@ -123,6 +123,9 @@
> > 
> >         /* Guillemot Webcam Hercules Dualpix Exchange*/
> >         { USB_DEVICE(0x06f8, 0x3005), .driver_info =
> >         USB_QUIRK_RESET_RESUME },
> > 
> > +       /* Midiman M-Audio Keystation 88es */
> > +       { USB_DEVICE(0x0763, 0x0192), .driver_info =
> > USB_QUIRK_RESET_RESUME }, +
> > 
> >         /* M-Systems Flash Disk Pioneers */
> >         { USB_DEVICE(0x08ec, 0x1000), .driver_info =
> >         USB_QUIRK_RESET_RESUME },
> > 
> > rf@ThinkpadSM:~/tmp>
> 
> Could you please send a formal patch with "Signed-off-by" and stuff
> upstream?
> 

hmm... I would but I've never done this before. No idea how to do this.

> 	Regards
> 		Oliver
