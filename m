Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab1BRVoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:44:23 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52220 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753744Ab1BRVoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:44:20 -0500
Date: Fri, 18 Feb 2011 16:44:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.37: USB Thermaltake Dock: Only see's 1 HDD? [SOLVED, but
 which option fixed it?]
In-Reply-To: <alpine.DEB.2.02.1102181621190.4561@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1102181643030.27433-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Justin Piszcz wrote:

> When I attach a dock with two HDD's on it in Linux, it only picks up one HDD,
> this is with a Thermaltake BlackX Duet, is there a special module/etc
> I need to load so it sees both drives on USB?
> 
> So I added some additional kernel options and now it seems fixed, but 
> this is more of a shotgun approach, instead of rebuilding/rebooting 
> several times does anyone know which module enabled support of > 1 HDD on 
> the USB dock as shown below?

> +CONFIG_SCSI_MULTI_LUN=y

That's the one.

Alan Stern

