Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0CVANd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 20:13:33 -0400
Received: from borg.medozas.de ([188.40.89.202]:54295 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab0CVANc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 20:13:32 -0400
Date: Mon, 22 Mar 2010 01:13:29 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
In-Reply-To: <20100303190753.GB11471@core.coreip.homeip.net>
Message-ID: <alpine.LSU.2.01.1003220110500.356@obet.zrqbmnf.qr>
References: <4B8C1867.7040201@cam.ac.uk> <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com> <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain> <20100303184132.GA11471@core.coreip.homeip.net> <alpine.LFD.2.00.1003031045390.3599@localhost.localdomai
 <20100303190753.GB11471@core.coreip.homeip.net>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2010-03-03 20:07, Dmitry Torokhov wrote:
>On Wed, Mar 03, 2010 at 10:52:43AM -0800, Linus Torvalds wrote:
>> On Wed, 3 Mar 2010, Dmitry Torokhov wrote:
>>> 
>>> Because in general ambient light sensor may have nothing to do
>>> with the screen brightness. The fact that all current uses are
>>> tied to controlling screen brightness is coincidential. You could
>>> use it as well to turn on the lights in the kitchen if it is
>>> getting too dark...
>> 
>> But my point is, it acts pretty much like a key on a keyboard 
>> _regardless_. 
>> 
>> Sure, you migth use it to turn up the lights too. But how is that 
>> different from having a switch to do the same? Again, it doesn't sound 
>> that different from a key to me.
>
>I guess for me the distinction is that the event was not caused by an
>action of a human being but by change in environment.

Power failure is also usually not caused by an action of a human, and
yet, (some brands/models of) uninterruptible power supplies present
these events through USBHID/input.
