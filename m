Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab0FVRgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:36:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56466 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab0FVRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AU0vBb44lCCJKK19EN/CE6hrrQl9RmH9600bmQ8DAxW9YP8nRe+fVpyaxxsVapW3k1
         LT6WeoKLbbmbP6XN/w8hk5Gjup5jBTEs0SabIdCxtS2j8Pg043sygpiKafXXOgrc6Hdo
         8xvRxvMQsEVOtJdM0IGycaT7lJ7w6XrXtx5qQ=
MIME-Version: 1.0
In-Reply-To: <20100622161329.GA14978@phenom.dumpdata.com>
References: <AANLkTim7_OzJfwbtk0fE5ScH8zZwZ_uJeo5pJFOhkHu_@mail.gmail.com>
	<20100622161329.GA14978@phenom.dumpdata.com>
Date: Tue, 22 Jun 2010 13:36:04 -0400
Message-ID: <AANLkTimUGrJRgW6Ao6mfqqfxBOIdM4HNiUEkcqpWeQfo@mail.gmail.com>
Subject: Re: Dell PowerEdge 4200 scsi, worked in 2.6.18, not in 2.6.26 (LOW 
	PRIORITY help request)
From: trouble daemon <troubledaemon@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

> The more worrying is the irqs firring. Try to use the 'irqpoll' parameter as
> it suggests.

Actually, it seems that it was solved with "noapic" kernel option, as was
suggested by Ben in the debian bug report at:

  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=586494

I do thank you for replying though. I am still not sure what exactly changed in
debian between epoch (</joke>) and 2.6.26 though, since the dell's
have been 100% perfect
out of the box in every single debian since circa 2002, when I got them.

I can deal with noapic, but I will try the irqpoll as well. I only noticed that
the dmesg was mentioning it after the noapic solved my problem. One thing I did
notice with noapic though, is that network ping's seem to round down, so I see
lots of "0.000 ms" pings on the local network. I assume that without apic that
the system is just using some sort of timer to poll the nics though.

On a side note, I also saw a 2007 post from Andrew Morton, I think, that was
complaining about noapic and trying to track down where the problem might have
started. Given the approx. 1999 munfacturing date (from what I can tell) of the
PowerEdge 4200 series, and a perfect linux history from at least debian potato
up until 2.6.26, you can bet some money that someone, somewhere out there,
changed yet another feature that required me to use noapic. More specifically,
it worked in 2.6.18 in debian etch/lenny, but broke in the next debian kernel,
2.6.26. ie: the change/problem lies somewhere between 19-26 inclusive
(depending on if my apic issue isn't simply a debian default/tweak
that messed things
up, of course)

Hopefully Andrew high lights on his name! :)

Anyways, thanks and sorry for the wall of text! l8r



troubled
