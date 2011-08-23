Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1HWJum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:50:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:46969 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1HWJuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:50:39 -0400
Date: Tue, 23 Aug 2011 11:50:36 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] drivers_base: platform: use always ->name for
 uevent
Message-ID: <20110823095036.GA23284@linutronix.de>
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de>
 <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
 <CACxGe6us1vaUgMmiZR-D9iSCQdw+vbVyZdBCkET_9p3AGyHwRQ@mail.gmail.com>
 <4E4937A4.5070204@linutronix.de>
 <CACxGe6sAOYf3r4i1no=+-RgTLuiRbxYkcy+9VFXaCZOXUOi_uw@mail.gmail.com>
 <20110822214154.GB20451@xanatos>
 <20110822215151.GA18397@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110822215151.GA18397@suse.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH | 2011-08-22 14:51:51 [-0700]:

>> Greg, do you want to take this patch through your driver core tree, or
>> would you prefer to have it come through the xHCI tree?
>
>I'll take it in my driver-core tree separate, as the others don't depend
>on this one, right?

Should the xhci series hit Linus' tree before your driver-core than
rmmod of the xhci-pci driver will lead to a crash.

>greg k-h

Sebastian
