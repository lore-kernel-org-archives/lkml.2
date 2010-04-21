Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0DUXlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:41:16 -0400
Received: from fieldses.org ([174.143.236.118]:40233 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab0DUXlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:41:15 -0400
Date: Wed, 21 Apr 2010 19:41:09 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-nfs@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] nfsd changes for 2.6.34
Message-ID: <20100421234108.GD23480@fieldses.org>
References: <20100306175212.GB22650@fieldses.org> <20100324142414.GE12057@fieldses.org> <20100329182443.GC3778@kroah.com> <20100330144054.GD11545@fieldses.org> <20100330200320.GB1693@kroah.com> <20100331193029.GC4937@fieldses.org> <20100421225048.GB27883@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421225048.GB27883@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 03:50:48PM -0700, Greg KH wrote:
> On Wed, Mar 31, 2010 at 03:30:29PM -0400, J. Bruce Fields wrote:
> > On Tue, Mar 30, 2010 at 01:03:20PM -0700, Greg KH wrote:
> > > Ok, care to backport them and send them to stable@kernel.org?  They
> > > don't all apply cleanly from what I can see.
> > 
> > Huh.  I just checked out 2.6.32.10 and tried applying the patches a
> > couple different ways, and the worst I got was stuff like:
> > 
> > 	patching file net/sunrpc/svc_xprt.c
> > 	Hunk #1 succeeded at 711 (offset 5 lines).
> > 
> > Is that enough that you don't consider them clean?
> > 
> > In any case, I'll follow up with patches generated against 2.6.32.10.
> 
> You are right, I don't know what I did wrong, sorry.  I've now queued
> all of these up for the next .32 tree, as they are already in
> .33-stable.

OK, thanks.--b.
