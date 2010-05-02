Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab0EBV7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 17:59:19 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50302 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754095Ab0EBV7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 17:59:17 -0400
Date: Sun, 2 May 2010 17:59:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
In-Reply-To: <20100502220628.0728d8d4@neptune.home>
Message-ID: <Pine.LNX.4.44L0.1005021756570.30701-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 May 2010, Bruno [UTF-8] Prémont wrote:

> > There's no way to fix the USB problem without knowing what goes wrong.  
> > Let's see how far you get before the system freezes on a kernel with 
> > CONFIG_USB_DEBUG enabled.
> 
> Am I missing something?
> 
> I've enabled CONFIG_USB_DEBUG but don't see any additional module parameter
> nor anything extra to toggle and I don't get more output than without it.

Depends what you mean by "output".  The kernel generates more log 
messages, but they may not get sent to your console.  You need to make 
sure the console's log level is set high enough to see debugging 
messages.  For example:

	echo 9 >/proc/sys/kernel/printk

or type Alt-SysRq-9.

Alan Stern

