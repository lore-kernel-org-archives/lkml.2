Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1CKQpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:45:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38708 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751800Ab1CKQpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:45:21 -0500
Date: Fri, 11 Mar 2011 11:45:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: andy.green@linaro.org
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
In-Reply-To: <4D7A4D52.6010501@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1103111141270.1975-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Andy Green wrote:

> > Like I say, it's not just MAC addresses that can need configuring this
> > way - it can be other random "you're wired up this way" type
> > information that would normally be figured out from the USB IDs.
> 
> Yes that's exactly why I was thinking it's a class of requirement that 
> could reasonably be a little API and extending platform_data to it.  So 
> anyone with onboard USB device can take advantage if they need to, 
> because I guess we see gradually more boards like that.
> 
> The driver knows well all about the actual device, but there is a class 
> of configuration information that is defined by the physical board 
> itself - as you say "how it is wired" - and needs to be passed into the 
> driver to inform it of its "functional configuration".  When that 
> functional configuration information is a feature of the board alone, 
> actually the board definition file is the right place for it.

I don't see the point of doing this for USB devices, or hot-pluggable 
devices in general.

Suppose you bought another USB device that was just like the on-board
one, and plugged it into the system.  Why should the driver need to
treat the on-board device any different from the hot-plugged device?

Or to put it another way...  With external, hot-plugged USB devices,
there is no need to know "how it is wired".  The fact that it is on a 
USB bus is the only information necessary.  Why does anyone need to
know more than this for on-board USB devices?

Alan Stern

