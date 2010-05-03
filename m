Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab0ECTX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:23:28 -0400
Received: from legolas.restena.lu ([158.64.1.34]:56862 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab0ECTX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:23:26 -0400
Date: Mon, 3 May 2010 21:23:12 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
Message-ID: <20100503212312.62b99fbb@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.1005031103180.1651-100000@iolanthe.rowland.org>
References: <20100503164820.384a371f@pluto.restena.lu>
	<Pine.LNX.4.44L0.1005031103180.1651-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 May 2010 Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 3 May 2010, Bruno [UTF-8] Prémont wrote:
> 
> > > Did you boot with "no_console_suspend"?  Are you using a VT console
> > > instead of X (a serial console may or may not work as well)?
> > 
> > Yes, I'm booting with no_console_suspend and console=ttyS0. On that
> > system there is no X. Multiple ttys are showing up on display with
> > KMS or VGA text mode (just the getty, all kernel and init output goes to
> > serial console as expected)
> 
> You're better off sending the console output to the display (or to
> both); I don't know how well serial consoles work with
> no_console_suspend.

How do I tell kernel to send to both?

At least when the keyboard is not plugged in I get about everything until
the very end, last message being 'SMP alternatives: switching to UP code'
(and the following line from dmesg after resume is 'Back to C!'

Thanks,
Bruno
