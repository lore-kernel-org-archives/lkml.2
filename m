Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab0ECPEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 11:04:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51481 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759427Ab0ECPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 11:04:35 -0400
Date: Mon, 3 May 2010 11:04:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: s2ram slow (radeon) / failing (usb)
In-Reply-To: <20100503164820.384a371f@pluto.restena.lu>
Message-ID: <Pine.LNX.4.44L0.1005031103180.1651-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 May 2010, Bruno [UTF-8] Prémont wrote:

> > Did you boot with "no_console_suspend"?  Are you using a VT console
> > instead of X (a serial console may or may not work as well)?
> 
> Yes, I'm booting with no_console_suspend and console=ttyS0. On that
> system there is no X. Multiple ttys are showing up on display with
> KMS or VGA text mode (just the getty, all kernel and init output goes to
> serial console as expected)

You're better off sending the console output to the display (or to
both); I don't know how well serial consoles work with
no_console_suspend.

Alan Stern

