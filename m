Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1FMOjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:39:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37169 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753517Ab1FMOi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:38:57 -0400
Date: Mon, 13 Jun 2011 10:38:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: balbi@ti.com, <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'open list:FREESCALE USB PER...'" <linuxppc-dev@lists.ozlabs.org>,
        "'open list:OMAP USB SUPPORT'" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH] usb:gadget: use min_t() macro instead of min()
In-Reply-To: <03b901cc29c0$6538e970$2faabc50$@org>
Message-ID: <Pine.LNX.4.44L0.1106131036430.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011, Tanya Brokhman wrote:

> > 
> > On Sun, Jun 12, 2011 at 02:14:46PM +0300, Tatyana Brokhman wrote:
> > > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> > 
> > I need a sensible commit log for this. Why do we need to change all
> > min() to min_t() ?
> > 
> 
> Actually, Alan asked me to make this change in one place in dummy_hcd. I
> wasn't aware of the min_t macro before that. So when I searched the code for
> other places I found quite a few and just thought that it would be "nicer"
> to use min_t() instead of min() with casting. 
> So we don't "need" to make this change. Everything works as is. This patch
> only makes the code look nicer, nothing more.
> I can elaborate the above in the commit log if you want.

The change I suggested involved replacing two typecasts with a single 
min_t.  All (or almost all) the places this patch touches currently 
contain only one typecast, so the motivation for changing them is a lot 
weaker.

Alan Stern

