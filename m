Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2BTRbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:31:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35923 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab2BTRbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:31:12 -0500
Date: Mon, 20 Feb 2012 18:31:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Egmont Koblinger <egmont@gmail.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
Message-ID: <20120220173106.GA17124@elf.ucw.cz>
References: <CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
 <20120215233002.GB20816@kroah.com>
 <CAGWcZkJHCRppjONbHuNop2r2X=n7efK94dQMXrA2=0Ou39bOAg@mail.gmail.com>
 <20120216005437.GA22858@kroah.com>
 <20120217192825.GE2707@elf.ucw.cz>
 <20120217225708.0f31f2ac@neptune.home>
 <CAGWcZk+_NpBZ2Gquv_ynXKdAivd3FhkHDDxu488y9Y9OrG2yfw@mail.gmail.com>
 <20120219221412.1b6912ba@neptune.home>
 <CAGWcZkJDi+AAG1KmvzAymBPt64JxKNizH-vCtsE7Lb=utFXG-g@mail.gmail.com>
 <CAGWcZkJZZ5FYTi+_VkjwhsZkwMtvxit5p+m2q0MARjEdEkiD4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGWcZkJZZ5FYTi+_VkjwhsZkwMtvxit5p+m2q0MARjEdEkiD4A@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> I'm quite new to this area, so any hint from terminal experts on how
> it should work would be appreciated.

One particular chance would be trying with some old kernel (like 2.4.0
or 2.6.0); if readline works as expected there, we have kernel
regression.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
