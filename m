Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1K1JEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:04:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63072 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab1K1JEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:04:51 -0500
Date: Mon, 28 Nov 2011 01:04:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: NeilBrown <neilb@suse.de>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, myungjoo.ham@gmail.com,
        linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111128090446.GB18919@core.coreip.homeip.net>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
 <201111251402.28016.arnd@arndb.de>
 <CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
 <20111127230836.GA29728@suse.de>
 <20111128123114.2601bd7c@notabene.brown>
 <20111128072713.GA17724@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128072713.GA17724@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 04:27:13PM +0900, Greg KH wrote:
> On Mon, Nov 28, 2011 at 12:31:14PM +1100, NeilBrown wrote:
> > 
> >  My own thought is that this deserves a new device class which allows easy
> >  hook-up of in-kernel signalling using notifications and which can be
> >  exported as input devices in much the same way the 'gpio' devices can be
> >  exported via gpio_keys.  The switch could also optionally be exported through
> >  sysfs much like gpio can be exported through sysfs.
> 
> That might also work, but again, odds are the HID spec already defines
> this type of "switch", so why recreate it as a different type of device?

HID does not map 1:1 on input. There are items in HID that are better
served by other subsystems.

-- 
Dmitry
