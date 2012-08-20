Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2HTJML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:12:11 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64961 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab2HTJMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:12:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120820004705.GA3710@thunk.org>
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
Date: Mon, 20 Aug 2012 11:12:07 +0200
Message-ID: <CAKr4yMxkrMXpVXmX9zgieTKrWmKtRx+Y2toZ2msrUdrBKFq13w@mail.gmail.com>
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: Alexander Thomas <alexander.thomas@esaturnus.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Carlos Alberto Lopez Perez <clopez@igalia.com>,
        Dan Luedtke <mail@danrl.de>, Jochen Striepe <jochen@tolot.escape.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 2:47 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> More and more consumer devices, including TV's, are network-enabled.
> I'm not at all convinced the USB memory disk model is the one which
> makes sense --- you can make a much better user experience work if you
> can rely on networking.  That way you don't have to move USB storage
> devices around, and USB storage devices are *slow* when the most
> common types are HDD's and crappy flash devices.  How many people are
> going to drop several hundred dollars for a USB-attached SSD, when
> using a networking transfer mechanism is much more convenient?

My two cents:

Flash drives are getting faster as well. Copying an 8GB file to/from a
USB drive is not excruciatingly slow and may be quicker and more
certain than figuring out how to get a working network connection in
some random place, if possible at all. If it is some lousy WiFi with
the base station at a distance, a flash drive will be faster. And
sometimes people just want to be sure that their data will be at a
certain place at a certain time without having to rely on a network
that may go down due to external reasons.

I also believe LanyFS (assuming that will be well-implemented) would
be a nice alternative to exFAT, and of course the kludge that is
FAT32. I do have serious doubts about how well it would be adopted.
Even if a single major vendor does not want to implement it or worse,
actively resists attempts to make it work on their platform, then it
already misses its most important goal. Of course, if we give up in
advance then it will certainly never happen…

Alexander
