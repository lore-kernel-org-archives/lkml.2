Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab1DNSei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:34:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:57400 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab1DNRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:40 -0400
Date: Thu, 14 Apr 2011 19:45:35 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Tanya Brokhman <tlinder@codeaurora.org>,
        gregkh@suse.de, linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: merge the two dummy_hcds into one
Message-ID: <20110414174535.GC27435@linutronix.de>
References: <20110414114605.GA17871@linutronix.de>
 <Pine.LNX.4.44L0.1104141141480.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104141141480.2487-100000@iolanthe.rowland.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Stern | 2011-04-14 11:45:34 [-0400]:

>In fact, the support for USB-3 HCDs is currently in flux.  Sarah Sharp 
>has submitted a whole bunch of patches to allow for the creation of 
>primary and secondary HCDs, representing the USB-2 and USB-3 root hubs 
>of an xHCI controller.  dummy-hcd should use the same mechanism.

Yeah, after I merged those two I've seen that I can't assign USB2 and
USB3 at the same time so I looked what xhci is doing in this case.

>This will means creating only one host-side platform device, and then 
>creating two usb_hcd structures below it.  Tanya's design should be 
>based on Sarah's work.

Yes, it makes sense.

>Alan Stern

Sebastian
