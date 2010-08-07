Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0HGUzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 16:55:17 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36383 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab0HGUzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 16:55:14 -0400
Date: Sat, 7 Aug 2010 13:55:10 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Subject: Re: [GIT PULL] notification tree - try 37!
Message-ID: <20100807205509.GY2927@count0.beaverton.ibm.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
 <20100806233431.GW2927@count0.beaverton.ibm.com>
 <20100807000624.GA14819@infradead.org>
 <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 03:15:14PM -0400, Eric Paris wrote:
> On Fri, 2010-08-06 at 20:06 -0400, Christoph Hellwig wrote:
> > On Fri, Aug 06, 2010 at 04:34:31PM -0700, Matt Helsley wrote:
> > > On Fri, Aug 06, 2010 at 11:58:39AM -0400, Eric Paris wrote:
> > > > Here it is again!  Another notification pull request!  There is still
> > > > future work to be done on notification, but nothing that I believe
> > > > others would call blocking or functional.  The work I plan to do
> > > > includes:
> > > > 
> > > > 1) Al has discussed the addition of a file_clone() call in the VFS which
> > > > would eliminate my use of __dentry_open() and would allow the removal of
> > > > the rather hideous FMODE_/O_NONOTIFY.
> > > 
> > > I did a quick search and can't find a mailing list post on this. Was
> > > it a private discussion or is there something I can read about what
> > > file_clone() will do?
> 
> No, it was from a face to face meeting and a couple of irc conversations
> talk about all of this stuff.  My understanding was that it was going to
> be a lot like dentry_open() only it was going to require a valid struct
> file and would return a new struct file.  One of the purposes of the new
> interface being the ability to set f_mode at a better time to eliminate
> the FMODE/O_ overlapping horror that fanotify requires to prevent
> recursion and deadlock.

Thanks Eric, that's the information I was looking for. I was curious
because there's a chance file_clone() as you described it may also be useful
for checkpoint/restart.

Cheers,
	-Matt Helsley
