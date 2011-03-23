Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab1CWPEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:04:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40680 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932625Ab1CWPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:04:48 -0400
Date: Wed, 23 Mar 2011 11:04:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Herbert Poetzl <herbert@13thfloor.at>
cc: linux-kernel@vger.kernel.org, Bernhard Kaindl <bk@suse.de>,
        Andi Kleen <andi@firstfloor.org>, <linux-usb@vger.kernel.org>
Subject: Re: debugging a modern laptop ...
In-Reply-To: <20110323034214.GC15541@MAIL.13thfloor.at>
Message-ID: <Pine.LNX.4.44L0.1103231102050.2211-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Herbert Poetzl wrote:

> 
> Greetings!
> 
> I'm trying to evaluate my options on debugging a recent
> laptop/notebook/table (and the Linux kernel on it of course) 
> from early bootup to diagnostics when the machine has locked
> up ...
> 
> normally the first thing I would do is to attach a serial
> console to monitor the early bootup and have some way to
> send sysrq triggers ... but here is the first problem,
> the thing might not even have a serial port at all ...
> 
> most modern devices have at least one usb port, but as far
> as I could figure out via google, there is no support for
> console or similar over usb (serial or not) atm
> (please feel free to correct me here :)

There _is_ support for a USB console (see CONFIG_USB_SERIAL_CONSOLE).  
However it may not be useful for diagnosing problems during boot,
because obviously the console won't operate until the USB stack is in
place and running.

Alan Stern

