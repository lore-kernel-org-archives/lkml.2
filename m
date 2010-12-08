Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0LHPn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:43:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47203 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0LHPn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:43:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ae9KIduQvP7/NCucdSuYw/QHXJiU4ImZlXwuo+kVZSYP6LrNQE3YOW2UGkKa04Hzu+
         /Jor5EjbK4RCPSZemdffXNGqPtbUMS9tzpIcHRccdyMgS5oLKIBA/ImouDHOlyVJAFj/
         4sXilPFjaDJw8Am7aA5ZkCZAhhtgmojRBfiq0=
MIME-Version: 1.0
In-Reply-To: <1291819459.28378.64.camel@laptop>
References: <19697.8378.717761.236202@pilspetsen.it.uu.se>
	<19707.34405.791777.298955@pilspetsen.it.uu.se>
	<20101205131702.GE9138@n2100.arm.linux.org.uk>
	<20101205141921.GF9138@n2100.arm.linux.org.uk>
	<19707.47304.977978.297596@pilspetsen.it.uu.se>
	<20101205162151.GH9138@n2100.arm.linux.org.uk>
	<1291812015.28378.24.camel@laptop>
	<20101208125548.GA9777@n2100.arm.linux.org.uk>
	<1291817076.28378.28.camel@laptop>
	<20101208142814.GE9777@n2100.arm.linux.org.uk>
	<1291819459.28378.64.camel@laptop>
Date: Wed, 8 Dec 2010 16:43:33 +0100
Message-ID: <AANLkTi=TYecfTGZ8iUDJPy+2HFTFYOjDEVxxE_1_Dvwf@mail.gmail.com>
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>,
        Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/8 Peter Zijlstra <a.p.zijlstra@chello.nl>:

> Like said, John Stultz was already looking at doing something like that
> because there's a number of architectures suffering this same problem
> and they're all already using part of the clocksource infrastructure to
> implement the sched_clock() interface simply because they only have a
> single hardware resource.

I was in on that discussion and for the Ux500 this patch was the
outcome:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6488/1

It seems to work, mostly, it's based off Nico's orion code and
just tries to make everything as explicit as possible.

Uwe has also been onto it I think.

Yours,
Linus Walleij
