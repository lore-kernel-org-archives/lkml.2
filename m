Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab2KRSxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 13:53:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37293 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2KRSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 13:53:01 -0500
Date: Sun, 18 Nov 2012 19:53:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-input@vger.kernel.org
Subject: Re: 3.7-rc3: mouses stopped working
Message-ID: <20121118185316.GA2844@elf.ucw.cz>
References: <20121115132849.GA4062@elf.ucw.cz>
 <alpine.LNX.2.00.1211151429240.15877@pobox.suse.cz>
 <20121115140736.GA2651@elf.ucw.cz>
 <alpine.LNX.2.00.1211151508350.15877@pobox.suse.cz>
 <20121116013405.GA2002@elf.ucw.cz>
 <alpine.LNX.2.00.1211161153290.20577@pobox.suse.cz>
 <20121116122400.GA10994@elf.ucw.cz>
 <alpine.LNX.2.00.1211161335180.20577@pobox.suse.cz>
 <20121118085638.GA2331@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121118085638.GA2331@core.coreip.homeip.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > That is correct and expected behavior.
> > 
> > > So it seems to be "/dev/input/mice" issue. Does it work for you?
> > 
> > Yes, it works for me properly (testing with rc4+, 1b42fc4 more precisely). 
> > Even after disconnect/reconnect cycle of USB mouse, I am getting events 
> > properly from /dev/input/mice (frankly I am surprised that you noticed ... 
> > Xorg has been using evdev driver for ages already by default, right?)
> > 
> > What was the last kernel version that worked for you in this respect?
> > 
> > Adding Dmitry and linux-input.
> 
> Does the patch below help?

Yes. With this patch, my mice are back.

Tested-by: Pavel Machek <pavel@ucw.cz>

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
