Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2HTGud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:50:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab2HTGua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:50:30 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Raymond Jennings <shentino@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Carlos Alberto Lopez Perez <clopez@igalia.com>,
        Dan Luedtke <mail@danrl.de>, Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
Date: Mon, 20 Aug 2012 08:49:18 +0200
Message-ID: <1410165.Y5eGtVk1DB@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.5.0-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1345442852.3906.0.camel@warfang.spyronet>
References: <1345333117-2826-1-git-send-email-mail@danrl.de> <20120820004705.GA3710@thunk.org> <1345442852.3906.0.camel@warfang.spyronet>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2012 23:07:32 Raymond Jennings wrote:
> On Sun, 2012-08-19 at 20:47 -0400, Theodore Ts'o wrote:
> > On Mon, Aug 20, 2012 at 01:06:20AM +0200, Carlos Alberto Lopez Perez wrote:
> > > 
> > > > I also seriously question the niche of people who want to use a thumb
> > > > drive to transfer > 4GB files.  Try it sometime and see what a painful
> > > > user experience it is....
> > > 
> > > Think for example on consumer devices, for example on most moderns TV
> > > you can plug a USB memory disk with videos and play them.
> > 
> > More and more consumer devices, including TV's, are network-enabled.
> > I'm not at all convinced the USB memory disk model is the one which
> > makes sense --- you can make a much better user experience work if you
> > can rely on networking.  That way you don't have to move USB storage
> > devices around, and USB storage devices are slow when the most
> > common types are HDD's and crappy flash devices.  How many people are
> > going to drop several hundred dollars for a USB-attached SSD, when
> > using a networking transfer mechanism is much more convenient?

The cost of such drives will not stay so high and the speed will leap drastically
once UAS over USB 3.0 will have become established.  And I am sure that you
don't want every content to go over the network. And far from everywhere will have
the bandwidth to transfer so much data. And of course you assume that you
know where you are going to need your content before you leave or have remote
access to your base system.

You may argue that networked transfers will take up a bigger slice of the cake, but
storage devices are far from dead, even for large amounts of data. And the definition
of largeness is growing.

	Regards
		Oliver

