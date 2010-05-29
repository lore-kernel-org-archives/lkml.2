Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0E2Dxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:53:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0E2Dxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:53:43 -0400
Date: Sat, 29 May 2010 00:53:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Daniel Mack <daniel@caiaq.de>,
       Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>, Jiri Slaby <jslaby@suse.cz>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers/media/dvb/dvb-usb/dib0700: CodingStyle fixes
Message-ID: <20100529005314.3cea43d8@pedra>
In-Reply-To: <20100524160215.GN30801@buzzloop.caiaq.de>
References: <AANLkTimSMLPf697B831bEyiSaeKgcOlKPmnu-0EXuqtX@mail.gmail.com>
	<1274714585-20544-1-git-send-email-daniel@caiaq.de>
	<20100524155624.GA3182@core.coreip.homeip.net>
	<20100524160215.GN30801@buzzloop.caiaq.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 24 May 2010 18:02:15 +0200
Daniel Mack <daniel@caiaq.de> escreveu:

> On Mon, May 24, 2010 at 08:56:24AM -0700, Dmitry Torokhov wrote:
> > On Mon, May 24, 2010 at 05:23:05PM +0200, Daniel Mack wrote:
> > > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > > Cc: Wolfram Sang <w.sang@pengutronix.de>
> > > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > > Cc: Jiri Slaby <jslaby@suse.cz>
> > > Cc: Dmitry Torokhov <dtor@mail.ru>
> > > Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> > > Cc: linux-media@vger.kernel.org
> > 
> > Not sure how I got on the list but chnages look good to me.
> 
> get_maintainer.pl :)

It did a very bad work in this case... It selected a random set of people,
but it forgot to add the email of the low level driver... 
This driver is maintained by Patrick (c/c). My name is also ok (as I am the
subsystem maintainer), but instead of c/c me, you can just copy
linux-media@vger.kernel.org, since I work directly with the patchwork
queue associated with the public ML.

Patrick,

Could you please review this patch and another one sent by Daniel at the ML?

-- 

Cheers,
Mauro
