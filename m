Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1KIIwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:52:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:53522 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab1KIIwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:52:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,483,1315206000"; 
   d="scan'208";a="34797404"
Date: Wed, 9 Nov 2011 10:52:34 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCHv6 01/19] usb: otg: Rename otg_transceiver to usb_phy
Message-ID: <20111109085234.GC2531@xps8300>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1319805325-24689-2-git-send-email-heikki.krogerus@linux.intel.com>
 <CAAe_U6JnWLioK_NCz03uCGd3T0aV56-M3MFgRUdJVX4nB1uhbg@mail.gmail.com>
 <20111108120635.GA2531@xps8300>
 <CAAe_U6KVvpJBe2nHzpyMN7iT6Q+1JJd5zfGUu99hq=agEjz1jQ@mail.gmail.com>
 <20111108150441.GI20728@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108150441.GI20728@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 08, 2011 at 05:04:43PM +0200, Felipe Balbi wrote:
> On Tue, Nov 08, 2011 at 08:28:15PM +0530, ABRAHAM, KISHON VIJAY wrote:
> > > Maybe I'm misunderstanding you, but sounds like you are still marrying
> > > OTG with transceivers.
> > I'm against the idea of usb_phy married with the transceiver (i.e
> > transceiver = twl6030 for instance)
> 
> I think the source of confusion is the split phy functionality on OMAPs.
> twl6030 basically provides VBUS/ID comparators which communicate VBUS/ID
> levels to internal PHY via a well-defined mailbox. We need a
> good way to write that down in source code.

OK, I think I understand now. So this issue is not in the scope of
these patches, right?

Br,

-- 
heikki
