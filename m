Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab0GTOIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:08:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33322 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757423Ab0GTOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:08:54 -0400
Date: Tue, 20 Jul 2010 10:08:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-Reply-To: <op.vf4y92vu7p4s8u@pikus>
Message-ID: <Pine.LNX.4.44L0.1007201007510.1631-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010, [utf-8] Michał Nazarewicz wrote:

> > On Mon, 19 Jul 2010, [utf-8] Michal‚ Nazarewicz wrote:
> >> 1/3: http://lkml.org/lkml/2010/7/8/317
> >> 	Adds serial to mass storage gadget and g_multi introducing
> >> 	fsg_string_serial_fill() macro used by abovementioned
> >> 	gadgets and file storage gadget.
> 
> On Mon, 19 Jul 2010 19:06:32 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> > Ah, yes.  My personal taste would be to write fsg_string_serial_fill_n
> > as an inline routine instead of as a macro, and not try to make it
> > separate from fsg_string_serial_fill.
> 
> Not sure what you meant by "make it separate from fsg_string_serial_fill".

I mean have a single function, called "fsg_string_serial_fill", instead 
of two separate macros called "fsg_string_serial_fill" and 
"fsg_string_serial_fill_n".

Alan Stern

