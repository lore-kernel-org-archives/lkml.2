Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab2INMEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:04:41 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57867 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758725Ab2INMEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:04:40 -0400
Date: Fri, 14 Sep 2012 14:04:23 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: navin patidar <navinp@cdac.in>, gregkh@linuxfoundation.org,
        mfm@muteddisk.com, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of
 usbip_host
Message-ID: <20120914120423.GD4152@breakpoint.cc>
References: <1347616403-3413-1-git-send-email-navinp@cdac.in>
 <50531832.3050902@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50531832.3050902@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 03:42:42PM +0400, Sergei Shtylyov wrote:
> >diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
> >index 92ced35..f584af8 100644
> >--- a/drivers/staging/usbip/stub_dev.c
> >+++ b/drivers/staging/usbip/stub_dev.c
> >@@ -233,6 +230,13 @@ static void stub_device_reset(struct usbip_device *ud)
> >
> >  	dev_dbg(&udev->dev, "device reset");
> >
> >+	/*reset tcp socket*/
> 
>    Add spaces after /* and before */, please.
> 
> >+	ud->tcp_socket = NULL;
> >+
> >+	/*reset kernel thread pointers */
> 
>    Here too.

I'm not sure it is required to comment the obvious things.

> WBR, Sergei

Sebastian
