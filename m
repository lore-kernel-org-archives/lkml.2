Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab0CaX2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:28:38 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:50870 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269Ab0CaX2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:28:36 -0400
Subject: Re: [PATCHv3] drivers/net/usb: Add new driver ipheth
From: Ben Hutchings <bhutchings@solarflare.com>
To: Greg KH <gregkh@suse.de>
Cc: "L. Alberto Gim?nez" <agimenez@sysvalve.es>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org, oliver@neukum.org,
       linville@tuxdriver.com, j.dumon@option.com, steve.glendinning@smsc.com,
       davem@davemloft.net, dgiagio@gmail.com, dborca@yahoo.com
In-Reply-To: <20100331232516.GA27730@suse.de>
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>
	 <1270064527-8485-1-git-send-email-agimenez@sysvalve.es>
	 <1270077538.8653.484.camel@localhost>  <20100331232516.GA27730@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 01 Apr 2010 00:28:30 +0100
Message-ID: <1270078110.8653.493.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2010 23:28:57.0020 (UTC) FILETIME=[EF2F4FC0:01CAD129]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17290.005
X-TM-AS-Result: No--33.193400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 16:25 -0700, Greg KH wrote:
> On Thu, Apr 01, 2010 at 12:18:58AM +0100, Ben Hutchings wrote:
> > On Wed, 2010-03-31 at 21:42 +0200, L. Alberto Gim??nez wrote:
[...]
> > > +#include <linux/usb.h>
> > > +#include <linux/workqueue.h>
> > > +
> > > +#define USB_VENDOR_APPLE        0x05ac
> > > +#define USB_PRODUCT_IPHETH     0x1290
> > > +#define USB_PRODUCT_IPHETH_3G   0x1292
> > > +#define USB_PRODUCT_IPHETH_3GS  0x1294
> > 
> > Apple doesn't assign device ids to ipheth so either the names are
> > incorrect or you should get proper device ids.  I believe the Linux
> > Foundation has a USB vendor id and could assign device ids under that.
> 
> You mean there is an application on the iphone that sets the device id
> here?  I thought this was the iphone device ids already assigned to
> apple.
[...]

That's why my first suggestion was that the names are incorrect; they
should probably include IPHONE not IPHETH.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

