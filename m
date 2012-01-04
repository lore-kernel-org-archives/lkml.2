Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2ADRPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:15:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab2ADRPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:15:41 -0500
Date: Wed, 4 Jan 2012 18:15:33 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, haiyangz@microsoft.com,
        hjanssen@microsoft.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jorge Bastos <mysql.jorge@decimal.pt>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>
Subject: Re: Reiserfs.c bug in 3.2-rc5
Message-ID: <20120104171533.GB28907@quack.suse.cz>
References: <20111213180707.GI11747@quack.suse.cz>
 <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
 <20120102115222.GA3626@quack.suse.cz>
 <20120103010826.GF3626@quack.suse.cz>
 <20120103123841.GA31457@quack.suse.cz>
 <1325604356.2095.23.camel@falcor>
 <CA+55aFzwq6XiAnX26uV+-mNsbGbnj0S=4nP5avPqKPw8OT+cmw@mail.gmail.com>
 <1325616312.2095.26.camel@falcor>
 <alpine.LRH.2.00.1201041046330.18098@tundra.namei.org>
 <CA+55aFxZ4_T8VRh6wAKC9-9PjsctrK1WnOmN-2EDNTeHA+OA4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxZ4_T8VRh6wAKC9-9PjsctrK1WnOmN-2EDNTeHA+OA4g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 03-01-12 16:18:01, Linus Torvalds wrote:
> On Tue, Jan 3, 2012 at 3:47 PM, James Morris <jmorris@namei.org> wrote:
> >>
> >> Just clarifying not all of commit fb88c2b, but only the
> >> security_old_inode_init_security() hunk.
> >
> > Agreed.
> >
> > And yep, it's ugly :-\
> 
> Ok, applied - along with another last-minute fix - and pushed out.
> 
> Can everybody please test and double-check that what I applied was
> what everybody agrees is the RightThing(tm)? I really wanted to do 3.2
> today, but both of those commits are of the "please double-check"
> kind, so..
  Thanks. The patch looks OK and current HEAD works for me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
