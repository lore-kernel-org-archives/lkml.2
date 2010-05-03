Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab0ECGeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 02:34:50 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:54433 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab0ECGes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 02:34:48 -0400
Date: Mon, 3 May 2010 08:34:49 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
Message-ID: <20100503083449.7355b457@pluto.restena.lu>
In-Reply-To: <Pine.LNX.4.44L0.1005021756570.30701-100000@netrider.rowland.org>
References: <20100502220628.0728d8d4@neptune.home>
	<Pine.LNX.4.44L0.1005021756570.30701-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 May 2010 17:59:17 -0400 (EDT) Alan Stern wrote:
> On Sun, 2 May 2010, Bruno [UTF-8] Prémont wrote:
> 
> > > There's no way to fix the USB problem without knowing what goes
> > > wrong. Let's see how far you get before the system freezes on a
> > > kernel with CONFIG_USB_DEBUG enabled.
> > 
> > Am I missing something?
> > 
> > I've enabled CONFIG_USB_DEBUG but don't see any additional module
> > parameter nor anything extra to toggle and I don't get more output
> > than without it.
> 
> Depends what you mean by "output".  The kernel generates more log 
> messages, but they may not get sent to your console.  You need to
> make sure the console's log level is set high enough to see debugging 
> messages.  For example:
> 
> 	echo 9 >/proc/sys/kernel/printk
> 
> or type Alt-SysRq-9.

I've been doing `dmesg -n 8` (9 is rejected as invalid) so it should
send out everything.
It looked like there was some more output during boot-up, but nothing
during suspend, at least up to the freezing point.

Bruno
