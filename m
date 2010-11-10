Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab0KJXkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:40:45 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18981 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab0KJXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:40:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6163"; a="61504475"
Date: Wed, 10 Nov 2010 15:40:42 -0800
From: David Brown <davidb@codeaurora.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: tlinder <tlinder@codeaurora.org>, USB list <linux-usb@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 1/2] Add usb_endpoint_descriptor to be part of the
 struct usb_ep
Message-ID: <20101110234042.GA25770@huya.qualcomm.com>
References: <1286092800-29107-1-git-send-email-tlinder@codeaurora.org>
 <Pine.LNX.4.44L0.1010031201050.26676-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1010031201050.26676-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 12:35:07PM -0400, Alan Stern wrote:

> > Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>
> ...
> 
> > diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> > index a857b7a..6264fba 100644
> > --- a/drivers/usb/gadget/file_storage.c
> > +++ b/drivers/usb/gadget/file_storage.c
> > @@ -3,6 +3,7 @@
> >   *
> >   * Copyright (C) 2003-2008 Alan Stern
> >   * All rights reserved.
> > + * Copyright (C) 2010 Code Aurora Forum. All rights reserved.
> >   *
> >   * Redistribution and use in source and binary forms, with or without
> >   * modification, are permitted provided that the following conditions
> 
> Speaking for myself only, I don't think people should add their own 
> copyright notices in files to which they have not made substantial 
> changes.  A little code motion and a small API adjustment don't seem 
> like large enough changes to justify this.  Some of the other files in 
> this patch have even smaller changes!

BTW, we agree on this.  People aren't supposed to be putting these
copyrights in, but they've gotten used to it up until now.

Tatyana, please be careful to not insert a Code Aurora Forum copyright
unless you change a significant portion of the file.

David
