Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731Ab1D0R1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:27:22 -0400
Received: from mx.treblig.org ([80.68.94.177]:45009 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759687Ab1D0R1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:27:20 -0400
Date: Wed, 27 Apr 2011 18:27:18 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Valdis.Kletnieks@vt.edu
Cc: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: Wonkiness with keyboard adapter - not sure if it's in USB or
	input systems
Message-ID: <20110427172718.GA16118@gallifrey>
References: <11501.1303832820@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11501.1303832820@localhost>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 18:25:22 up 68 days, 18:58,  1 user,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> Running 2.6.39-rc1-mmotm at the moment on a Dell Latitude E6500, that wants an
> external USB keyboard/mouse and monitor when it's in its docking station in the
> office. I have an old Microsoft Natural keyboard that has a PS/2 connector, but
> I like the tactile feel so I didn't want to get rid of it.  So we recently got
> some PS2->USB adapters, which appear in lsusb as follows:
> 
> Bus 001 Device 006: ID 0e8f:0020 GreenAsia Inc. USB to PS/2 Adapter
> 
> Now, when I first power up the laptop in the docking station, it *does* see the
> keyboard just fine, and Grub is able to talk to it, and everything works (this
> particular boot, I was able to hit the space bar to get to the Grub menu, use
> arrow up/down to move between entries, all looked good).  So it isn't like the
> device needs any initialization above and beyond what the BIOS is doing at
> initial power-on.
> 
> However, when the Linux kernel starts up, it sees the adapter, but doesn't
> recognize key presses until I disconnect and then reconnect the keyboard:

I've experienced the same behaviour on at least two very different machines
(one a Tosh laptop, the other a Dell desktop), in both cases using a Model M
PS/2 keyboard connected to two different USB<->PS/2 converters (one a 
really ancient Belkin one and the other a recent no-name soap-on-a-rope type
thing).

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
