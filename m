Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1CIXom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:44:42 -0500
Received: from kroah.org ([198.145.64.141]:45209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1CIXoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:44:38 -0500
Date: Wed, 9 Mar 2011 15:42:38 -0800
From: Greg KH <greg@kroah.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH v2] pch_uart: reference clock on CM-iTC
Message-ID: <20110309234238.GA4071@kroah.com>
References: <4D74A600.7070302@compulab.co.il>
 <20110307200733.GA18849@kroah.com>
 <4D761F7F.2030908@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D761F7F.2030908@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 02:22:23PM +0200, Denis Turischev wrote:
> Default clock source for UARTs on Topcliff is external UART_CLK.
> On CM-iTC USB_48MHz is used instead. After VCO2PLL and DIV
> manipulations UARTs will receive 192 MHz.
> Clock manipulations on Topcliff are controlled in pch_phub.c
> 
> v2: redone against the linux-next tree

Are you sure?  I still get the following conflicts when applying it:
	patching file drivers/misc/pch_phub.c
	Hunk #2 succeeded at 42 with fuzz 2 (offset -5 lines).
	Hunk #3 FAILED at 626.
	1 out of 3 hunks FAILED -- saving rejects to file drivers/misc/pch_phub.c.rej
	patching file drivers/tty/serial/pch_uart.c
	Hunk #1 succeeded at 21 (offset 1 line).
	Hunk #2 succeeded at 1405 (offset 1 line).

confused,

greg k-h
