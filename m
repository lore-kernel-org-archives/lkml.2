Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1FMTDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 15:03:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57824 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752744Ab1FMTDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 15:03:45 -0400
Date: Mon, 13 Jun 2011 15:03:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: balbi@ti.com, <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'open list:FREESCALE USB PER...'" <linuxppc-dev@lists.ozlabs.org>,
        "'open list:OMAP USB SUPPORT'" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH] usb:gadget: use min_t() macro instead of min()
In-Reply-To: <03db01cc29f4$d472bcb0$7d583610$@org>
Message-ID: <Pine.LNX.4.44L0.1106131503040.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011, Tanya Brokhman wrote:

> > 
> > The change I suggested involved replacing two typecasts with a single
> > min_t.  All (or almost all) the places this patch touches currently
> > contain only one typecast, so the motivation for changing them is a lot
> > weaker.
> > 
> You're right. So what's the final call on this one? Do you think it can be
> merged or you prefer not change anything? I personally think the code looks
> nicer using min_t instead of min with casting but that's just my opinion and
> of course there are arguments against this patch.

I don't care either way.  It's up to you and Felipe.

Alan Stern

