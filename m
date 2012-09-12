Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2ILUZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:25:33 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:41292 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2ILUZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:25:31 -0400
Date: Wed, 12 Sep 2012 20:25:30 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>
cc: Greg KH <gregkh@linuxfoundation.org>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
In-Reply-To: <20120912062259.GC18563@arwen.pp.htv.fi>
Message-ID: <alpine.DEB.2.00.1209122025020.17903@utopia.booyaka.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi> <1346935540-1792-1-git-send-email-balbi@ti.com> <alpine.DEB.2.00.1209062137000.11516@utopia.booyaka.com> <alpine.DEB.2.00.1209112141220.9444@utopia.booyaka.com> <20120912062259.GC18563@arwen.pp.htv.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, 12 Sep 2012, Felipe Balbi wrote:

> On Tue, Sep 11, 2012 at 10:02:48PM +0000, Paul Walmsley wrote:
> 
> > The bad news is that N800 no longer boots -- or the UART dies during 
> > serial init:
> > 
> > http://www.pwsan.com/omap/testlogs/test_tty_next_e36851d0/20120910020323/boot/2420n800/2420n800_log.txt
> > 
> > The problem doesn't seem to affect the 2430SDP.
> > 
> > Could you put together a patch to fix N800?
> 
> I'll see what I can do. BTW, is that log with DEBUG_LL enabled ?

Yes.  Here's the .config that was used on N800:

http://www.pwsan.com/omap/testlogs/test_tty_next_e36851d0/20120910020323/build/n800_b_testconfig/Kconfig


- Paul
