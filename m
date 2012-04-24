Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2DXP6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:58:41 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:50486 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab2DXP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:58:39 -0400
Date: Tue, 24 Apr 2012 23:58:43 +0800
From: Wang YanQing <udknight@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Anil Nair <anilcoll90@gmail.com>, Greg KH <greg@kroah.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [RFC]Is usb port number fixed?
Message-ID: <20120424155843.GA3804@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Anil Nair <anilcoll90@gmail.com>, Greg KH <greg@kroah.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <20120424021600.GA5283@udknight>
 <Pine.LNX.4.44L0.1204241010270.1511-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204241010270.1511-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 10:14:05AM -0400, Alan Stern wrote:
> In drivers/usb/core/hub.c, look through the hub_events() routine.  
> There are several function calls similar to this one:
> 
> 			ret = hub_port_status(hub, i,
> 					&portstatus, &portchange);
> 
> Here i is the port number.  This asks the hub to send back status and 
> change information for port i.  (See also the code for the 
> hub_port_status() and get_port_status() routines.)

Thanks, I get it.

On Tue, Apr 24, 2012 at 07:52:44PM +0530, anil wrote:
> The USB specification Table 11-13 describes the hub descriptor in
> detail.
> The following data structure struct usb_hub_descriptor defined in
> "drivers/usb/core/hub.h" of Linux  Kernel source contains information
> about the hub descriptor,
> 
>                       struct usb_hub_descriptor {
>                             _u8 bDescLength;
>                           _u8 bDescriptorType;
>                              _u8 bNbrPorts;
>                        _le16 wHubCharacteristics;
>                           _u8 bPwrOn2PwrGood;
>                          _u8 bHubContrCurrent;
>                                    }
> 
> The bNbrPorts  member contains information on the number of
> downstream-facing ports the hub supports. The structure which i have
> provided is in reference to Linux Kernel Version 2.6 series for Linux
> Kernel Version 3.0+, Please consult an expert.
>   	Is this information you wanted?
> 

Yes, It is want I wanted.But maybe "11.5.3.1 Labeling" show more footprint.

Thanks, all guys.
All you give me a very good explanation about the sentence below:

"High quality support from experts available instantly over the Internet at
no charge has played a major role in stitching together a huge Linux community"

which come from the <<Essential Linux Device Drivers>>.

Cheers.

Udknight
