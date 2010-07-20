Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab0GTDBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 23:01:07 -0400
Received: from mail001.aei.ca ([206.123.6.130]:36833 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941Ab0GTDBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 23:01:03 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Michel =?utf-8?q?D=C3=A4nzer?= <michel@daenzer.net>
Subject: Re: Regression 2.6.34+ -> 2.6.34-rc5: radeon KMS rs780 problems
Date: Mon, 19 Jul 2010 23:00:14 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc5-crc+; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        dri-devel@lists.freedesktop.org
References: <201007171856.39564.edt@aei.ca> <1279550060.9986.89.camel@thor.local>
In-Reply-To: <1279550060.9986.89.camel@thor.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007192300.15124.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 July 2010 10:34:20 Michel Dänzer wrote:
> On Sam, 2010-07-17 at 18:56 -0400, Ed Tomlinson wrote: 
> > 
> > My 790gx chipset supplies an rs780.  With .34+ all is ok.
> > With .35-rc5 basic function seems ok (kde works) but games like
> > extreme tux racer have problems.  The cursor does not display when on
> > the tux racer window and various objects flicker on and off as I
> > attempt to play the game.   
> 
> Sounds like it might be
> https://bugs.freedesktop.org/show_bug.cgi?id=28341 . Does the X driver
> patch attached there fix the problem?

Michel,

xf86-video-ati git from today fails.  Applying the revert patch in the above message
fixes the problem.  Its an interesting bug in that the kernel change triggers the 
driver bug.  Might be a good idea to get this fixed, one way or another, before
-35 gets released?

Let me know if you want me to test anything.

Thanks,
Ed Tomlinson
