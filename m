Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0ICNEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:04:53 -0400
Received: from mail.wdtv.com ([66.118.69.84]:37690 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab0ICNEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:04:52 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2010 09:04:51 EDT
From: Gene Heskett <gene.heskett@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 0/5] tty: move stuff around
Date: Fri, 3 Sep 2010 08:58:07 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.4; KDE/4.5.1; i686; ; )
Cc: mhw@wittsend.com, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier.adi@gmail.com>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de> <1283440567.5202.19.camel@canyon.wittsend.com> <201009031413.00266.arnd@arndb.de>
In-Reply-To: <201009031413.00266.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009030858.08060.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 03, 2010, Arnd Bergmann wrote:
>On Thursday 02 September 2010, Michael H. Warfield wrote:
>> On Tue, 2010-08-31 at 12:42 +0200, Rogier Wolff wrote:
>> > The question is whether I want the drivers I wrote to stay or to
>> > go away?
>> > 
>> > I was paid years ago to make Linux support the Specialix cards. It
>> > started with one card from their line of "solutions", but the others
>> > followed.
>> 
>> My story is very similar with the Computone Intelliport II boards.  I
>> was paid (in hardware) by Computone to get their drivers integrated
>> into the mainline kernel and support them.  That was a long long time
>> ago. The boards have not been manufactured in over a decade and the
>> company went of of business a long time ago.  I'm still in touch with
>> several of the old developers that use to work there.
>
>Ok, so it sounds both of you successfully managed to maintain the device
>drivers way beyond the life time of the hardware, great work!
>
>Let's send the drivers into their well-earned retirement in
>drivers/staging where they can die from a natural cause. If someone
>still has a use for them after all, we can always bring them back and he
>or she can become the new maintainer ;-).
>
>	Arnd

Dipping an interested oar in this water, but speaking purely from the user 
viewpoint;

That is all well and good I suppose, but please ask yourselves if there are 
suitable _modern_ replacements for this hardware, and are the drivers 
available in linux?

If there are not suitable replacements, buy able at the likes of newegg et 
all, then this attitude seems a bit premature.

I presume the same can be said of the rocketport drivers, I haven't seen 
those boards for sale in yonks, but there are probably at least 1 of them 
in every television station in the country (USA), doing wire service 
capture.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The fact that 47 PEOPLE are yelling and sweat is cascading down my
SPINAL COLUMN is fairly enjoyable!!
