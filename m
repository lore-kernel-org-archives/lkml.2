Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab2DTRPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:15:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55088 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2DTRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:15:38 -0400
Date: Fri, 20 Apr 2012 10:15:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com
Subject: Re: [PATCH v8 resend 6/6] Documentation/extcon: porting guide for
 Android kernel switch driver.
Message-ID: <20120420171534.GA29519@kroah.com>
References: <20120420033209.GA17930@kroah.com>
 <1334898987-7800-1-git-send-email-myungjoo.ham@samsung.com>
 <1334898987-7800-7-git-send-email-myungjoo.ham@samsung.com>
 <20120420162529.GA31744@kroah.com>
 <20120420170519.GB3080@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420170519.GB3080@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 06:05:20PM +0100, Mark Brown wrote:
> On Fri, Apr 20, 2012 at 09:25:29AM -0700, Greg KH wrote:
> 
> > Ok, I've applied this, but I don't know if we really need this in the
> > kernel tree.  How many out-of-tree android switch drivers are there?
> > Who needs to know this information?
> 
> Every phone with a headset jack will have at least one switch if it's
> running on Android.  People doing system integration will generally need
> to know about this, at least until we've got the ALSA detection stuff
> integrated with extcon.

Ok, but where are those drivers at?  Any pointers to them so I can start
sucking them into the tree and doing this conversion?

Is this, and the wakelock stuff, holding back a torrent of drivers to be
submitted somewhere?  Or are they buried in vendor trees, never to be
seen?

thanks,

greg k-h
