Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0CZU7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:59:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab0CZU7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:59:22 -0400
Date: Fri, 26 Mar 2010 21:59:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v3 1/6] hid: new driver for PicoLCD device
In-Reply-To: <20100326102951.3b9ecda1@neptune.home>
Message-ID: <alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz>
References: <20100324233707.7243b04d@neptune.home> <20100324234022.0361bd80@neptune.home> <20100326065656.GC26602@core.coreip.homeip.net> <20100326102951.3b9ecda1@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010, Bruno Prémont wrote:

> > > +	for (i = 0; i < PICOLCD_KEYS; i++) {
> > > +		int key = ((int *)idev->keycode)[i];
> > 
> > Keycodes are now short, not int. Also, just do:
> > 
> > 		input_set_capability(idev, EV_KEY, data->keycode[i]);
> > 
> > > +		if (key < KEY_MAX && key >= 0)
> > > +			input_set_capability(idev, EV_KEY, key);
> 
> Oops, I was not careful enough when switching over...

Dmitry, thanks a lot for rapid review the driver.

Bruno, could you please fix this and submit a followup 1/6 patch, so that 
I could queue the driver in my tree?

I have almost finished going over the driver and haven't encountered any 
other issues that would require immediate fixing.

Still, it would be nice to have the framebuffer/LCD/backlight bits 
reviewed by respective subsystem maintainers. But I'll probably queue the 
driver nevertheless and add potential ACKs later.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
