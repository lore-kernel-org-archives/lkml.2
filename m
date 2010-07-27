Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0G0ATz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 20:19:55 -0400
Received: from norkia.v3.sk ([91.210.183.14]:54691 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab0G0ATk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 20:19:40 -0400
Subject: Re: [PATCH] V7: Add support for non-PDP11 v7 filesystems
From: Lubomir Rintel <lkundrak@v3.sk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <20100726165231.ea38062e.akpm@linux-foundation.org>
References: <20100724135128.GA11645@ZenIV.linux.org.uk>
	 <1280098756-26522-1-git-send-email-lkundrak@v3.sk>
	 <20100726165231.ea38062e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 02:19:15 +0200
Message-ID: <1280189955.26200.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-26 at 16:52 -0700, Andrew Morton wrote:
> On Mon, 26 Jul 2010 00:59:16 +0200
> Lubomir Rintel <lkundrak@v3.sk> wrote:
> 
> > This adds byte order autodetection (of PDP-11 and LE filesystems).
> > No attempt is made to detect big-endian filesystems -- were there any?
> > Tested with PDP-11 v7 filesystems and PC-IX maintenance floppy.
> 
> Which kernel is this against?  My v7_fill_super() is significantly
> different from yours.

This depends on [PATCH] V7: Adjust sanity checks for some volumes
<1279761108-302-1-git-send-email-lkundrak@v3.sk>.

It might be that I've messed up something in the communication so that
the dependency was not immediately clear. To be honest, I'm not very
familiar with the way reviews and adjustements to patches are tracked.
What have I done wrong, here? How am I supposed to follow up with a
change to a single patch of a multi-patch (be it just two in this case)
set?

-- 
Flash is the Web2.0 version of blink and animated gifs.
                                     -- Stephen Smoogen

