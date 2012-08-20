Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2HTNWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:22:01 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45857 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab2HTNV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:21:59 -0400
Date: Mon, 20 Aug 2012 09:21:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Alexander Thomas <alexander.thomas@esaturnus.com>
Cc: Carlos Alberto Lopez Perez <clopez@igalia.com>,
        Dan Luedtke <mail@danrl.de>, Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
Message-ID: <20120820132141.GC5197@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Alexander Thomas <alexander.thomas@esaturnus.com>,
	Carlos Alberto Lopez Perez <clopez@igalia.com>,
	Dan Luedtke <mail@danrl.de>,
	Jochen Striepe <jochen@tolot.escape.de>,
	Marco Stornelli <marco.stornelli@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	lanyfs@librelist.com
References: <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
 <1345371135.4441.2.camel@tunafish>
 <5030BC7E.3030000@gmail.com>
 <1345383264.4441.56.camel@tunafish>
 <20120819120254.GA2369@pompeji.miese-zwerge.org>
 <1345390432.2716.34.camel@tunafish>
 <20120819210455.GA9208@thunk.org>
 <5031716C.1060003@igalia.com>
 <20120820004705.GA3710@thunk.org>
 <CAKr4yMxkrMXpVXmX9zgieTKrWmKtRx+Y2toZ2msrUdrBKFq13w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKr4yMxkrMXpVXmX9zgieTKrWmKtRx+Y2toZ2msrUdrBKFq13w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 11:12:07AM +0200, Alexander Thomas wrote:
> 
> Flash drives are getting faster as well. Copying an 8GB file to/from a
> USB drive is not excruciatingly slow and may be quicker and more
> certain than figuring out how to get a working network connection in
> some random place, if possible at all. If it is some lousy WiFi with
> the base station at a distance, a flash drive will be faster. And
> sometimes people just want to be sure that their data will be at a
> certain place at a certain time without having to rely on a network
> that may go down due to external reasons.

OK --- and how many of these situations will you be using such a
stripped down operating system that you can't afford to implement ntfs
or ext4?  Samsung is considering an Android-power point-and-shoot
digital camera[1].  And mobile phones are using Android phones where
implementation of ext4 is a worked example (and not particularly
difficult, either).

If this file system had gotten implemented for Arduino first (and
someone actually had a worked example of why you would need > 4GB
vfiles for an Arduino device --- if I were going to be implementing
something with video I'd probably be using a full Linux kernel), the
claimed use case might be more compelling.  It would also demonstrate
that in fact this was a decent file system for an Arduino device (and
to demonstrate the infinite stack recursion problem wouldn't be a
gaping security hole problem for them either).

I used to think that we would need an IP unencumbered file system,
given issues around TomTom and Microsoft, but these days, given how
quickly Linux has taken over the embedded and mobile landscape[2] for
all but the most tiniest of devices, I don't think that's as important
of an issue, since we can just simply use a native linux file system.
In the time that it would take to get some other new file system
adopted across the industry, it's likely Linux will have enough market
share to perhaps compel the other OS vendors to provide
interoperability solutions.  (Just as the BSD folks have implemented
ext2 support; Linux hasn't bothered to implement FFS2 support....)

	  	  	      		- Ted

[1] http://www.engadget.com/2012/03/14/samsung-researching-android-based-digital-camera/

[2] http://money.cnn.com/2012/08/08/technology/smartphone-market-share/index.html
