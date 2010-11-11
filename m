Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab0KKGbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 01:31:48 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11038 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab0KKGbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 01:31:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6163"; a="61456442"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'David Brown'" <davidb@codeaurora.org>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: "'USB list'" <linux-usb@vger.kernel.org>,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        "'Greg Kroah-Hartman'" <gregkh@suse.de>,
        "'Michal Nazarewicz'" <m.nazarewicz@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Kernel development list'" <linux-kernel@vger.kernel.org>
References: <1286092800-29107-1-git-send-email-tlinder@codeaurora.org> <Pine.LNX.4.44L0.1010031201050.26676-100000@netrider.rowland.org> <20101110234042.GA25770@huya.qualcomm.com>
In-Reply-To: <20101110234042.GA25770@huya.qualcomm.com>
Subject: RE: [RFC/PATCH 1/2] Add usb_endpoint_descriptor to be part of the struct usb_ep
Date: Thu, 11 Nov 2010 08:34:26 +0200
Message-ID: <002101cb816a$7ef541f0$7cdfc5d0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuBMKzv7rrIl6fqRU2ck8nwXeh5eAAObG9w
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: David Brown [mailto:davidb@codeaurora.org] 
Sent: Thursday, November 11, 2010 1:41 AM
To: Alan Stern
Cc: tlinder; USB list; David Brownell; Greg Kroah-Hartman; Michal
Nazarewicz; Andrew Morton; Kernel development list
Subject: Re: [RFC/PATCH 1/2] Add usb_endpoint_descriptor to be part of the
struct usb_ep

On Sun, Oct 03, 2010 at 12:35:07PM -0400, Alan Stern wrote:

> > Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>
> ...
> 
> > diff --git a/drivers/usb/gadget/file_storage.c
b/drivers/usb/gadget/file_storage.c
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

[Brokhman, Tanya] - Yes, this was already removed in the latest version of
the patch. Thanks!

David

