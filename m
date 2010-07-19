Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713Ab0GSRGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:06:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58032 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753705Ab0GSRGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:06:33 -0400
Date: Mon, 19 Jul 2010 13:06:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-Reply-To: <op.vf3mmwoa7p4s8u@pikus>
Message-ID: <Pine.LNX.4.44L0.1007191256480.1657-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010, [utf-8] Michał Nazarewicz wrote:

> >>> I have lost track of the current state of that patch.  When you finish
> >>> updating it, please post it for my review.
> 
> > On Mon, 19 Jul 2010, Michal‚ Nazarewicz wrote:
> >> This is still the v3 patchset (only the first two should be of
> >> interest to you), still want me to resend?
> 
> On Mon, 19 Jul 2010 18:14:01 +0200, Alan Stern wrote:
> > Or provide a URL for them in the mailing list archives.
> 
> 1/3: http://lkml.org/lkml/2010/7/8/317
> 	Adds serial to mass storage gadget and g_multi introducing
> 	fsg_string_serial_fill() macro used by abovementioned
> 	gadgets and file storage gadget.

Ah, yes.  My personal taste would be to write fsg_string_serial_fill_n 
as an inline routine instead of as a macro, and not try to make it 
separate from fsg_string_serial_fill.

> 2/3: http://lkml.org/lkml/2010/7/8/318
> 	Modification of Yann Cantin's patch, delta in comment for 1/3.

I have only one objection to this patch: The new parameter's name 
should be "serial", not "serial_parm".  (Compare it to all the other 
parameter names.)

> 3/3: http://lkml.org/lkml/2010/7/8/316
> 	Modification of patch for earlier patch for g_multi.  Dunno if
> 	you want to look at it.  Providing URL for completeness.

No comment on that one.

As for the discussion between you and David...  I haven't tried to 
follow the details very carefully.  I get the impression that the two 
of you are talking past each other instead of coming to grips with a 
genuine issue.

Alan Stern

