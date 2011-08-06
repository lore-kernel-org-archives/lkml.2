Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1HFW0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 18:26:45 -0400
Received: from mx.treblig.org ([80.68.94.177]:54934 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab1HFW0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 18:26:43 -0400
Date: Sat, 6 Aug 2011 23:26:42 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Stephan Bertl <stephan@bweb.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: ThinkPad Edge: psmouse.c: TouchPad at
	isa0060/serio4/input0 lost sync at byte 1
Message-ID: <20110806222642.GD23569@gallifrey>
References: <4E37A13B.50106@bweb.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4E37A13B.50106@bweb.at>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 23:24:57 up 169 days, 23:57,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephan Bertl (stephan@bweb.at) wrote:
> [1.]
> psmouse.c: TouchPad at isa0060/serio4/input0 lost sync at byte 1
>
> [2.]
> Hi, i have got a ThinkPad Edge 11 with TouchPad and TrackPoint, and the  
> TouchPad repeatedly looses sync, so it ´hangs for some seconds, i tried  
> various workarounds with kernel parameters like i8042.noloop  
> i8042.nomux=1 psmouse.proto=imps etc... nothing really works.

Is this something that started happening on recent kernels or has it
always happened on that hardware?

When it loses sync what are the symptoms - does it just blip for a second
or so and you get that message, or do you get a 10s of seconds lockup
that also involves the keyboard?

I ask because one of my fathers machines has developed a repeated
PS/2 resync problem that I'm trying to track down; it's symptoms
are that it apparently locks up with no keyboard/mouse response
for a while and if it's lucky then does a resync.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
