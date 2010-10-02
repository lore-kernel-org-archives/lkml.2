Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab0JBV7x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 17:59:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab0JBV7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 17:59:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ted Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #19062] Dirtiable inode bdi default != sb bdi btrfs
Date: Sat, 2 Oct 2010 23:58:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera> <sQALkqF1FWE.A.15D.bo6nMB@chimera> <20101002165433.GL21129@thunk.org>
In-Reply-To: <20101002165433.GL21129@thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010022358.35972.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 02, 2010, Ted Ts'o wrote:
> On Sun, Sep 26, 2010 at 10:04:15PM +0200, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19062
> > Subject		: Dirtiable inode bdi default != sb bdi btrfs
> > Submitter	: Cesar Eduardo Barros <cesarb@cesarb.net>
> > Date		: 2010-09-23 0:54 (4 days old)
> > Message-ID	: <4C9AA546.6050201@cesarb.net>
> > References	: http://marc.info/?l=linux-kernel&m=128520328929595&w=2
> 
> Note: I'm seeing this warning (Dirtiable inode bdi default != sb bdi)
> when I moved from 2.6.36-rc3 to 2.6.36-rc6, using ext4 as a root
> partition, and running mke2fs and e2fsck on ext2, ext3, and ext4 file
> systems.  So I'm seeing this as a known regression from rc3 to rc6.
> Maybe it's different bug with ext4, but in any case, it's highly
> annoying.

Thanks for the info.  I wonder who should see this report.

Andrew, do you know whose area that is?
