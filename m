Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab0EDHxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 03:53:09 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45157 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756985Ab0EDHxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 03:53:07 -0400
Date: Tue, 4 May 2010 06:16:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Arve Hj?nnev?g <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend
 blockers from user-space
Message-ID: <20100504041618.GB5326@ucw.cz>
References: <Pine.LNX.4.44L0.1005021755320.30701-100000@netrider.rowland.org>
 <201005031703.11448.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005031703.11448.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-05-03 17:03:11, Rafael J. Wysocki wrote:
> On Sunday 02 May 2010, Alan Stern wrote:
> > On Sun, 2 May 2010, Rafael J. Wysocki wrote:
> > 
> > > Hmm.  It doesn't seem to be possible to create two different suspend blockers
> > > using the same file handle.  So, what exactly is a process supposed to do to
> > > use two suspend blockers at the same time?
> > 
> > Open the file twice, thereby obtaining two file handles.
> 
> Well, that's what I thought.
> 
> I must admit I'm not really comfortable with this interface.  IMO it would
> be better if _open() created the suspend blocker giving it a name based on
> the name of the process that called it.  Something like
> "<process name>_<timestamp>" might work at first sight.
> 
> Alternatively, "<process_name><number>", where <number> is 0 for the first
> suspend blocker created by the given process, 1 for the second one etc., also
> seems to be doable.

Yes please.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
