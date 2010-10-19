Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0JSUaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:30:05 -0400
Received: from kroah.org ([198.145.64.141]:49484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273Ab0JSUaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:30:01 -0400
Date: Tue, 19 Oct 2010 13:29:12 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Valdis.Kletnieks@vt.edu, Dave Airlie <airlied@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, codalist@telemann.coda.cs.cmu.edu,
        ksummit-2010-discuss@lists.linux-foundation.org,
        autofs@linux.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>,
        Samuel Ortiz <samuel@sortiz.org>, Jan Kara <jack@suse.cz>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        netdev@vger.kernel.org, Anders Larsen <al@alarsen.net>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Bryan Schumaker <bjschuma@netapp.com>,
        Christoph Hellwig <hch@infradead.org>,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-fsdevel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>, Andrew Hendry <andrew.hendry@gmail.com>,
        linux-media@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
Message-ID: <20101019202912.GA30133@kroah.com>
References: <201009161632.59210.arnd@arndb.de>
 <21406.1287512693@localhost>
 <20101019193735.GA4043@kroah.com>
 <201010192140.47433.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010192140.47433.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 09:40:47PM +0200, Oliver Neukum wrote:
> Am Dienstag, 19. Oktober 2010, 21:37:35 schrieb Greg KH:
> > > So no need to clean it up for multiprocessor support.
> > > 
> > > http://download.intel.com/design/chipsets/datashts/29067602.pdf
> > > http://www.intel.com/design/chipsets/specupdt/29069403.pdf
> > 
> > Great, we can just drop all calls to lock_kernel() and the like in the
> > driver and be done with it, right?
> 
> No,
> 
> you still need to switch off preemption.

Hm, how would you do that from within a driver?

thanks,

greg k-h
