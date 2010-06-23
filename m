Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0FWNwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:52:40 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:64923 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab0FWNwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:52:38 -0400
Message-ID: <40fb3584df99f83ffbf7633909412ea0.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20100623122344.372e5f75@neptune.home>
References: <alpine.LNX.2.00.1006211442350.13809@pobox.suse.cz>
    <d1cda632f4cdb650a68119903473fbb4.squirrel@intranet.cs.nmsu.edu>
    <20100623122344.372e5f75@neptune.home>
Date: Wed, 23 Jun 2010 07:51:36 -0600
Subject: Re: [PATCH] hid Logitech G13 Driver 0.0.5
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: Bruno =?iso-8859-1?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Marek Vasut" <marek.vasut@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>, "Jaya Kumar" <jayakumar.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, felipe.balbi@nokia.com,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       florianschandinat@gmx.de, krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-fbdev@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 June 2010 "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu> wrote:
>> I've been waiting to resubmit until I get some of the userspace
>> libraries
>> and utilities a little more mature. There were some things I was
>> exposing
>> to sysfs that I didn't absolutely need, and some others that I needed to
>> add.
>>
>> The cairo and papyrus libraries are (preliminarily) fully working. Once
>> I
>> make sure I have everything the daemon will need I'll resubmit the
>> driver,
>> and once that is done I was planning on submitting the libs/utils to
>> Fedora.
>>
>> For now, I've been dropping Fedora 12/13 patches and kernel SRPMS here:
>> http://miskatonic.cs.nmsu.edu/g13/
>>
>> And the userspace libraries/utilities are at:
>> http://g13.sourceforge.net
>>
>> As for the g13fb on the G15... I would imagine it could be done, but I
>> don't have a G15 so I can't say for sure.
>>
>> If I had to guess I think you'll have to take the core functionality of
>> the keyboard driver and extend it with the fb code in the _same_ driver
>> if
>> the keyboard and display use a similar design to the G13.
>>
>> The G13 uses the same endpoint for both keyboard input and display
>> messages, and since a USB endpoint can't be shared across drivers both
>> will have to reside in the same driver.
>>
> Bruno Prémont wrote:
> Hi Rick,
>
> Please check how your driver behaves if the framebuffer is still in use
> (open and/or mmapped) by some userspace process when you unplug the
> keyboard.
>
> Probably you will get hit be the same complaints from kernel I was seeing
> with PicoLCD driver (see my patch http://lkml.org/lkml/2010/5/30/15 that
> is expected to fix it on PicoLCD side, the refcounting part of the patch)
>

Will do. Thanks for the heads up.

