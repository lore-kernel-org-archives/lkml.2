Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1FYMKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 08:10:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49409 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751100Ab1FYMKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 08:10:53 -0400
Date: Sat, 25 Jun 2011 08:10:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kirill Smelkov <kirr@mns.spb.ru>
cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: EHCI: Move sysfs related bits into ehci-sysfs.c
In-Reply-To: <2a537d4dffef27cc7839eb19889eaa035edd44f9.1308933456.git.kirr@mns.spb.ru>
Message-ID: <Pine.LNX.4.44L0.1106250807270.1039-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011, Kirill Smelkov wrote:

> The only sysfs attr implemented so far is "companion" from ehci-hub.c,
> but in the next patch we are going to add another sysfs file, so prior
> to that let's structure things and move already-in-there sysfs code to
> separate file.
> 
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> diff --git a/drivers/usb/host/ehci-sysfs.c b/drivers/usb/host/ehci-sysfs.c
> new file mode 100644
> index 0000000..347c8cb
> --- /dev/null
> +++ b/drivers/usb/host/ehci-sysfs.c
> @@ -0,0 +1,94 @@
> +/*
> + * Copyright (C) 2001-2004 by David Brownell

One little note...  It's understandable that you put this line here,
but it isn't really appropriate.  All the code you're moving into this
new file was written by me.

Apart from that one issue,

Acked-off-by: Alan Stern <stern@rowland.harvard.edu>

