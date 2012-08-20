Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2HTGHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:07:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49795 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2HTGHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:07:51 -0400
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: Raymond Jennings <shentino@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Carlos Alberto Lopez Perez <clopez@igalia.com>,
        Dan Luedtke <mail@danrl.de>, Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
In-Reply-To: <20120820004705.GA3710@thunk.org>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
	 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
	 <1345371135.4441.2.camel@tunafish> <5030BC7E.3030000@gmail.com>
	 <1345383264.4441.56.camel@tunafish>
	 <20120819120254.GA2369@pompeji.miese-zwerge.org>
	 <1345390432.2716.34.camel@tunafish> <20120819210455.GA9208@thunk.org>
	 <5031716C.1060003@igalia.com>  <20120820004705.GA3710@thunk.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 19 Aug 2012 23:07:32 -0700
Message-ID: <1345442852.3906.0.camel@warfang.spyronet>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 20:47 -0400, Theodore Ts'o wrote:
> On Mon, Aug 20, 2012 at 01:06:20AM +0200, Carlos Alberto Lopez Perez wrote:
> > 
> > > I also seriously question the niche of people who want to use a thumb
> > > drive to transfer > 4GB files.  Try it sometime and see what a painful
> > > user experience it is....
> > 
> > Think for example on consumer devices, for example on most moderns TV
> > you can plug a USB memory disk with videos and play them.
> 
> More and more consumer devices, including TV's, are network-enabled.
> I'm not at all convinced the USB memory disk model is the one which
> makes sense --- you can make a much better user experience work if you
> can rely on networking.  That way you don't have to move USB storage
> devices around, and USB storage devices are *slow* when the most
> common types are HDD's and crappy flash devices.  How many people are
> going to drop several hundred dollars for a USB-attached SSD, when
> using a networking transfer mechanism is much more convenient?
> 
> > And I doubt that the majority of this consumer devices are able to read
> > nothing more than FAT32 file-systems, so the 4GB limit is a big problem.
> > And here is where Microsoft is pushing their exFAT FS since it allows
> > working with 4GB+ files without the NTFS overhead.
> 
> We'll see how popular a heavily IP-encumbered file system will be,
> especially given that its main use case is for devices which are so
> constrained that they can't afford to use a "real file system" (like
> ntfs or ext4 or some other more sophisticated file system), but which
> nevertheless needs to be able to handle 4GB+ files.

My two cents:

After seeing microsoft's attack on TomTom over the vfat patents I
honesstly would consider it a good move to have an alternative free
format available.

> I'm sure there will be some use cases that might fit that niche, but
> it seems pretty tiny.  And this is completely ignoring what might
> happen if in the future people take 1gig fiber connections to the home
> (such as what many people in Kansas City will be enjoying very
> shortly) for granted....
> 
> > As a side note, it would be possible to write a driver for exFAT and get
> > it merged upstream on the Linux Kernel without "breaking any law"?
> > Goggling I found an attempt to write such driver but seems that never
> > got merged:  https://lkml.org/lkml/2009/2/8/24
> 
> You'll need to talk to a lawyer about that, since that's fundamentally
> a legal question.
> 
> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


