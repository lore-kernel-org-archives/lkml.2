Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0CVMZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:25:44 -0400
Received: from smtp5.freeserve.com ([193.252.22.151]:26011 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754087Ab0CVMZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:25:42 -0400
X-ME-UUID: 20100322122537823.C8E821C00084@mwinf3542.me.freeserve.com
Date: Mon, 22 Mar 2010 12:25:17 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Suspend/hibernate wireless regression with 2.6.33 kernel
Message-ID: <20100322122517.1743e896@boulder.homenet>
In-Reply-To: <20100317015113.4e833e1c@boulder.homenet>
References: <20100317015113.4e833e1c@boulder.homenet>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 01:51:13 +0000
Chris Vine <chris@cvine.freeserve.co.uk> wrote:
> Hi,
> 
> I have a Lenovo S12 (Ideapad) netbook with a BCM4312 802.11b/g
> [14e4:4315] wireless device.  Although this works using the PIO option
> in kernel 2.6.33/2.6.33.1 (not with DMA) using the in-kernel b43
> driver, and also works with the broadcom proprietary wl driver, it
> breaks after a suspend or hibernate. Attempts to bring up the wlan0
> interface with 'ifconfig wlan0 up' after suspension or hibernation
> results in the following message (although nothing is revealed by
> dmesg):
> 
>   SIOCSIFFLAGS: Unknown error 132
> 
> More worryingly, when suspending or hibernating, acpi sometimes
> but not always appears to write to the CMOS.  On two occasions I
> have observed that although a reboot into 2.6.33 would work (until
> there is another suspension or hibernation), wireless becomes
> permanently switched off when rebooting into 2.6.32 or earlier - when
> reading from the BIOS, kernel 2.6.32 and below appears to think that
> the radio has been disabled even though the BIOS set-up screen
> disagrees. When this occurs, I have to restore all defaults in the
> BIOS to get wireless to come on again in kernel 2.6.32 and less.

[snip]

This regression between 2.6.32 and 2.6.33 is still present in
2.6.34-rc2, with an added twist.  In 2.6.34-rc2, on resuming from
suspension or hibernation, my rfkill button is completely disabled -
that is, I cannot switch wireless on, but I also cannot switch bluetooth
off.

Chris


