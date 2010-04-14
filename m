Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0DNUVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:21:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56007 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754582Ab0DNUVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:21:53 -0400
Date: Wed, 14 Apr 2010 16:21:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.1: USB camera hung_task_timeout_secs >120 seconds
In-Reply-To: <201004142137.36524.maciej.rutecki@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004141619360.1716-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Maciej Rutecki wrote:

> (Add CCs)
> 
> Can you check, that eg. 2.6.30 and latest -RC works OK?
> 
> On wtorek, 13 kwietnia 2010 o 22:07:20 Martin Mokrejs wrote:
> > Hi,
> >    I am not certain whether the stacktrace I received is just intentional
> > to attract developer eyes or whether this is actually a false alarm:
> > mounting USB mass storage device media always takes a long while.
> > This is a P4-M laptop with Kouwell 7004 FW/USB2.0 PCMCIA card.
> > Comments?
> > Thanks,
> > martin

If 2.6.34-rc doesn't work, please post a usbmon trace showing what
happens when the device is plugged in.  Instructions are in
Documentation/usb/usbmon.txt.

Alan Stern

