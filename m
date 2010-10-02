Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab0JBQyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:54:38 -0400
Received: from thunk.org ([69.25.196.29]:55516 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab0JBQyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:54:37 -0400
Date: Sat, 2 Oct 2010 12:54:33 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: Re: [Bug #19062] Dirtiable inode bdi default != sb bdi btrfs
Message-ID: <20101002165433.GL21129@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	Cesar Eduardo Barros <cesarb@cesarb.net>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
 <sQALkqF1FWE.A.15D.bo6nMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sQALkqF1FWE.A.15D.bo6nMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 10:04:15PM +0200, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19062
> Subject		: Dirtiable inode bdi default != sb bdi btrfs
> Submitter	: Cesar Eduardo Barros <cesarb@cesarb.net>
> Date		: 2010-09-23 0:54 (4 days old)
> Message-ID	: <4C9AA546.6050201@cesarb.net>
> References	: http://marc.info/?l=linux-kernel&m=128520328929595&w=2

Note: I'm seeing this warning (Dirtiable inode bdi default != sb bdi)
when I moved from 2.6.36-rc3 to 2.6.36-rc6, using ext4 as a root
partition, and running mke2fs and e2fsck on ext2, ext3, and ext4 file
systems.  So I'm seeing this as a known regression from rc3 to rc6.
Maybe it's different bug with ext4, but in any case, it's highly
annoying.

						- Ted
