Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1JQSwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:52:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59011 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751667Ab1JQSwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:52:22 -0400
Date: Mon, 17 Oct 2011 14:52:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mpn@google.com>
cc: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 0/3] get rid of USB_GADGET_{DUAL,SUPER}SPEED
In-Reply-To: <cover.1318875728.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1110171450490.1749-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> Sorry for the delay.
> 
> Rebased on top of <git://gitorious.org/usb/usb.git gadget>.
> 
> This has been only compile-tested.

Did you compile-test the various intermediate stages (i.e., after the 
first patch and after the second patch)?  I bet not, because the change 
to file_storage.c in 3/3 belongs in 2/3.

Alan Stern

