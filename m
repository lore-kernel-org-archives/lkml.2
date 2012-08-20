Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab2HTLgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:36:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60597 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2HTLgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:36:51 -0400
Date: Mon, 20 Aug 2012 13:36:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Carlos Alberto Lopez Perez <clopez@igalia.com>,
        Dan Luedtke <mail@danrl.de>, Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
Message-ID: <20120820113649.GB906@elf.ucw.cz>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
 <1345371135.4441.2.camel@tunafish>
 <5030BC7E.3030000@gmail.com>
 <1345383264.4441.56.camel@tunafish>
 <20120819120254.GA2369@pompeji.miese-zwerge.org>
 <1345390432.2716.34.camel@tunafish>
 <20120819210455.GA9208@thunk.org>
 <5031716C.1060003@igalia.com>
 <20120820004705.GA3710@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820004705.GA3710@thunk.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I also seriously question the niche of people who want to use a thumb
> > > drive to transfer > 4GB files.  Try it sometime and see what a painful
> > > user experience it is....
> > 
> > Think for example on consumer devices, for example on most moderns TV
> > you can plug a USB memory disk with videos and play them.
> 
> More and more consumer devices, including TV's, are network-enabled.
> I'm not at all convinced the USB memory disk model is the one which
> makes sense --- you can make a much better user experience work if
> you

More and more, but USB sticks are still more common... and exchange
format would be nice.

Currently, I'm just using VFAT + NTFS, but both have disadvantages.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
