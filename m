Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1E1OP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 10:15:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54428 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753483Ab1E1OP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 10:15:26 -0400
Date: Sat, 28 May 2011 10:15:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: balbi@ti.com, "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>,
        <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <003201cc1d27$39fe02e0$adfa08a0$@org>
Message-ID: <Pine.LNX.4.44L0.1105280958490.16594-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011, Tanya Brokhman wrote:

> I was making the same change for SS and I think that if you're about to send
> this patch to Greg, it might need a small addition:
> At the moment dummy_hcd supports high_speed so I think if this option is no
> longer configurable by user you should set this flag when dummy_hcd is
> selected:
> 
> config USB_DUMMY_HCD
> 	tristate
> 	depends on USB_GADGET_DUMMY_HCD
> 	default USB_GADGET
> 	select USB_GADGET_SELECTED
> 	select USB_GADGET_DUALSPEED

Right now USB_GADGET_DUALSPEED is selected under USB_GADGET_DUMMY_HCD, 
which is the right place for it, I think.  Same as all the other UDC 
drivers.

Alan Stern

