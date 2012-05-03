Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab2ECEhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 00:37:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38061 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2ECEg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 00:36:59 -0400
Date: Wed, 2 May 2012 21:36:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: Olof Johansson <olof@lixom.net>, Daniel Mack <daniel@caiaq.de>,
        Daniel Mack <zonque@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: eeti_ts: Mark as CONFIG_BROKEN
Message-ID: <20120503043651.GA11830@core.coreip.homeip.net>
References: <1333777207-4151-1-git-send-email-olof@lixom.net>
 <20120407070206.GA17623@core.coreip.homeip.net>
 <4F8089A9.6080704@raumfeld.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8089A9.6080704@raumfeld.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sven,

On Sat, Apr 07, 2012 at 08:38:33PM +0200, Sven Neumann wrote:
> Hi,
> 
> On 07.04.12 09:02, Dmitry Torokhov wrote:
> >On Fri, Apr 06, 2012 at 10:40:07PM -0700, Olof Johansson wrote:
> >>This seems to have been broken since 2010, so obviously noone actually
> >>cares about the driver:
> >>
> >>make[4]: *** [drivers/input/touchscreen/eeti_ts.o] Error 1
> >>drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':
> >>drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]
> >>
> >>irq_to_gpio isn't available on most platforms today, so the driver
> >>will need some rework by someone who has hardware access and can test
> >>(to make sure that, for example, switching to level interrupts and just
> >>keep taking them while there's more to process works).
> >>
> >>I guess it could just be scheduled for removal, but let's start with
> >>marking it CONFIG_BROKEN.
> >
> >Well, it probably works quite well on arches that do have irq_to_gpio(),
> >let's ask Daniel and Sven if they still have this hardware and if they
> >can try the patch below that implements what you suggested.
> 
> This hardware is still in use and we also still follow kernel
> development and try to update our customer devices to recent kernel
> versions regularly. Currently we are at 3.1.10 and the touchscreen
> works well with that. I'll try to update to a more recent kernel
> next week and will try your patch.
> 

Did you have a chance to test the patch?

Thanks.

-- 
Dmitry
