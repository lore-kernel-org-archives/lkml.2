Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab0E0Pex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:34:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:36862 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0E0Peu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:34:50 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Paul@smtp1.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527163359.23e83bdd@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005271053420.3239-100000@iolanthe.rowland.org>
	 <1274972956.27810.5161.camel@twins>
	 <20100527163359.23e83bdd@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 17:34:39 +0200
Message-ID: <1274974479.27810.5247.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 16:33 +0100, Alan Cox wrote:
> On Thu, 27 May 2010 17:09:16 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2010-05-27 at 11:06 -0400, Alan Stern wrote:
> > > 
> > >         Opportunistic suspends are okay.
> > > 
> > >         The proposed userspace API is too Android-specific.
> > 
> > I would argue opportunistic suspends are not ok, and therefore the
> > proposed API is utterly irrelevant.
> 
> Assuming you are happy that opportunistically entering C6 and the like is
> ok via ACPI can you explain why you have a problem with opportunistic
> suspend and why it is different to a very deep sleep CPU state such as we
> have now (and which on many embedded platforms we deal with *is* sleeping
> external devices too)

Agreed, but I understood the opportunistic suspend line from Alan Stern
to mean the echo opportunistic > /sys/power/foo thing.

If you view it as an extra deep idle state I have no problem with it
(because its simply an idle state, nothing magic about those).
