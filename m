Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315Ab0GSOTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:19:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38970 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933971Ab0GSOTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:19:08 -0400
Date: Mon, 19 Jul 2010 10:19:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
In-Reply-To: <op.vf3amtx27p4s8u@pikus>
Message-ID: <Pine.LNX.4.44L0.1007191017400.1657-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010, [utf-8] Michał Nazarewicz wrote:

> >> The second patch (by Yann Cantin) adds a serial module
> >> parameter to
> >> the File Storage Gadget.  FSG is not a composite
> >> gadget
> 
> > OK, so it should add a module param with the same
> > name as used elsewhere ...
> 
> I was going to propose that but file storage gadget uses names
> different from composite anyway (ie. vendor and product instead of
> idVendor and idProduct) so I dunno if it's worth it.  As a matter
> of fact, "serial" seems to match the other names better.
> 
> > makes sense to me.  I Alan Acks that patch, go for it.
> 
> I believe Alan already agreed on this patch.  I'm merely updating
> it to use the changes introduced by my patch to mass storage and
> g_multi.

I have lost track of the current state of that patch.  When you finish
updating it, please post it for my review.

Alan Stern

