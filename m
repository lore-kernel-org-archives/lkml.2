Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0FWKaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:30:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab0FWKaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:30:05 -0400
Date: Wed, 23 Jun 2010 12:30:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>,
       Marek Vasut <marek.vasut@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Jaya Kumar <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       florianschandinat@gmx.de, krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] hid Logitech G13 Driver 0.0.5
In-Reply-To: <20100623122344.372e5f75@neptune.home>
Message-ID: <alpine.LNX.2.00.1006231229230.13809@pobox.suse.cz>
References: <alpine.LNX.2.00.1006211442350.13809@pobox.suse.cz> <d1cda632f4cdb650a68119903473fbb4.squirrel@intranet.cs.nmsu.edu> <20100623122344.372e5f75@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010, Bruno Prémont wrote:

> Please check how your driver behaves if the framebuffer is still in use
> (open and/or mmapped) by some userspace process when you unplug the
> keyboard.
> 
> Probably you will get hit be the same complaints from kernel I was seeing
> with PicoLCD driver (see my patch http://lkml.org/lkml/2010/5/30/15 that
> is expected to fix it on PicoLCD side, the refcounting part of the patch)

BTW I'd like to have this fixed, but I haven't seen any Acks from 
framebuffer people, which I'd really like to have before taking it through 
my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
