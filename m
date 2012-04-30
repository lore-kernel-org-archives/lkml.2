Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2D3IwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:52:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab2D3IwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:52:22 -0400
From: Oliver Neukum <oliver@neukum.org>
To: opensuse-factory@opensuse.org
Subject: Re: [opensuse-factory] Re: usb midi keyboard broken [3.3.3 regression] [SOLUTION]
Date: Mon, 30 Apr 2012 10:48:21 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Steffen =?iso-8859-1?q?M=FCller?= <steffen.mueller@radio-frei.de>,
        Alan Stern <stern@rowland.harvard.edu>, Jiri Slaby <jslaby@suse.cz>,
        stable@kernel.org, Greg KH <greg@kroah.com>,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1204271122550.1690-100000@iolanthe.rowland.org> <201204281730.04550.oliver@neukum.org> <5861865.YnqskICckP@thinkpadsm.rf-studio>
In-Reply-To: <5861865.YnqskICckP@thinkpadsm.rf-studio>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204301048.21852.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 28. April 2012, 23:26:58 schrieb Steffen Müller:
> yes, it works now without blacklisting for autosuspend after build patched 
> kernel with this in drivers/usb/core/quirks.c
> 
> rf@ThinkpadSM:~/tmp> diff -uNr quirks-org.c quirks.c 
> --- quirks-org.c        2012-04-28 23:19:45.440959001 +0200
> +++ quirks.c    2012-04-28 20:38:50.000000000 +0200
> @@ -123,6 +123,9 @@
>         /* Guillemot Webcam Hercules Dualpix Exchange*/
>         { USB_DEVICE(0x06f8, 0x3005), .driver_info = USB_QUIRK_RESET_RESUME },
>  
> +       /* Midiman M-Audio Keystation 88es */
> +       { USB_DEVICE(0x0763, 0x0192), .driver_info = USB_QUIRK_RESET_RESUME },
> +
>         /* M-Systems Flash Disk Pioneers */
>         { USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
>  
> rf@ThinkpadSM:~/tmp> 

Could you please send a formal patch with "Signed-off-by" and stuff
upstream?

	Regards
		Oliver
