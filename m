Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab1CISCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:02:52 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:34119 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275Ab1CISCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:02:50 -0500
Date: Wed, 9 Mar 2011 19:02:09 +0100
From: Ivan Djelic <ivan.djelic@parrot.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC v2 1/3] Shared BCH ECC library
Message-ID: <20110309180209.GA29754@parrot.com>
References: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>
 <20110308111548.GA6628@parrot.com>
 <1299587945.2754.32.camel@localhost>
 <alpine.LFD.2.00.1103082206270.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103082206270.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 09:08:36PM +0000, Thomas Gleixner wrote:
> On Tue, 8 Mar 2011, Artem Bityutskiy wrote:
> 
> > On Tue, 2011-03-08 at 12:15 +0100, Ivan Djelic wrote:
> > > On Mon, Feb 07, 2011 at 02:09:30PM +0000, Ivan Djelic wrote:
> > > > Hello,
> > > > 
> > > > The first patch of this series contains a new generic BCH ECC library.
> > > 
> > > Hi,
> > > 
> > > It has been a month since this patch was posted, and I did not receive any
> > > comment/review yet.
> > 
> > I can add it to my l2 tree and may be dwmw2 can merge it then. But could
> > you please re-send a version with better Kconfig help messages?
> 
> I had a quick look. The code looks pretty clean and well documented,
> though I did not dig into the details. There are a few comments
> "lifted from ...", I hope the code which is copied does not cause any
> license issues.

The code you are referring to is in the public domain (from the famous "Bit
Twiddling Hacks" page). I added this information in version v3 of my patch.
Thanks for the feedback!

Ivan
