Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1LLKMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:12:14 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:53305 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab1LLKML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:12:11 -0500
X-SENDER-IP: [85.230.170.8]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao5hAJrS5U5V5qoIPGdsb2JhbABDiU6eZoEWgSwZAQEBATcygXIBAQU6HCMQCAMOCi4UJQoaiB20KBSKdmMEjHkoh0+FW4xO
X-IronPort-AV: E=Sophos;i="4.71,337,1320620400"; 
   d="scan'208";a="14363537"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 12 Dec 2011 11:26:30 +0100
To: Oliver Neukum <oneukum@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] Input: bcm5974 - Fix USB autosuspend
Message-ID: <20111212102630.GA2479@polaris.bitmath.org>
References: <1323680764-2155-1-git-send-email-rydberg@euromail.se>
 <201112121002.53004.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112121002.53004.oneukum@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:02:52AM +0100, Oliver Neukum wrote:
> Am Montag, 12. Dezember 2011, 10:06:04 schrieb Henrik Rydberg:
> > @@ -895,6 +857,10 @@ static int bcm5974_probe(struct usb_interface *iface,
> >         /* save our data pointer in this interface device */
> >         usb_set_intfdata(iface, dev);
> >  
> > +       error = bcm5974_start_traffic(dev);
> > +       if (error)
> > +               goto err_free_buffer;
> > +
> >         return 0;
> >  
> >  err_free_buffer:
> > -- 
> 
> Why do you want to start traffic before open() in probe() ?
> It doesn't make sense to ask a device to deliver data nobody
> wants.

Seems I was a bit trigger happy here, will send another one.

Thanks,
Henrik
