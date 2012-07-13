Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2GMHBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 03:01:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41477 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2GMHBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 03:01:10 -0400
Date: Fri, 13 Jul 2012 00:01:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: Olof Johansson <olof@lixom.net>, Daniel Mack <daniel@caiaq.de>,
        Daniel Mack <zonque@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: eeti_ts: Mark as CONFIG_BROKEN
Message-ID: <20120713070102.GA2223@core.coreip.homeip.net>
References: <1333777207-4151-1-git-send-email-olof@lixom.net>
 <20120407070206.GA17623@core.coreip.homeip.net>
 <4F8089A9.6080704@raumfeld.com>
 <20120503043651.GA11830@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503043651.GA11830@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 09:36:51PM -0700, Dmitry Torokhov wrote:
> Hi Sven,
> 
> On Sat, Apr 07, 2012 at 08:38:33PM +0200, Sven Neumann wrote:
> > Hi,
> > 
> > On 07.04.12 09:02, Dmitry Torokhov wrote:
> > >On Fri, Apr 06, 2012 at 10:40:07PM -0700, Olof Johansson wrote:
> > >>This seems to have been broken since 2010, so obviously noone actually
> > >>cares about the driver:
> > >>
> > >>make[4]: *** [drivers/input/touchscreen/eeti_ts.o] Error 1
> > >>drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':
> > >>drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]
> > >>
> > >>irq_to_gpio isn't available on most platforms today, so the driver
> > >>will need some rework by someone who has hardware access and can test
> > >>(to make sure that, for example, switching to level interrupts and just
> > >>keep taking them while there's more to process works).
> > >>
> > >>I guess it could just be scheduled for removal, but let's start with
> > >>marking it CONFIG_BROKEN.
> > >
> > >Well, it probably works quite well on arches that do have irq_to_gpio(),
> > >let's ask Daniel and Sven if they still have this hardware and if they
> > >can try the patch below that implements what you suggested.
> > 
> > This hardware is still in use and we also still follow kernel
> > development and try to update our customer devices to recent kernel
> > versions regularly. Currently we are at 3.1.10 and the touchscreen
> > works well with that. I'll try to update to a more recent kernel
> > next week and will try your patch.
> > 
> 
> Did you have a chance to test the patch?

*ping*

It would be nice to get driver in mainline compile [and work] again...

Thanks.

-- 
Dmitry
