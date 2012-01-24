Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab2AXRna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:43:30 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37889 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab2AXRn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:43:29 -0500
Date: Tue, 24 Jan 2012 11:43:30 -0600
From: Ben Myers <bpm@sgi.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [41/42] xfs: validate acl count
Message-ID: <20120124174330.GQ8262@sgi.com>
References: <20120110215031.GA19398@kroah.com> <20120110215024.482323323@clark.kroah.org> <20120111074135.GA30829@lst.de> <20120111150021.GB23608@suse.de> <20120111150532.GL20739@sgi.com> <20120113161727.GB6519@sgi.com> <20120113181952.GA30393@suse.de> <20120113194218.GB14857@sgi.com> <20120113195206.GA16462@suse.de> <20120124163301.GA6077@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124163301.GA6077@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On Tue, Jan 24, 2012 at 05:33:01PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 13, 2012 at 11:52:06AM -0800, Greg KH wrote:
> > > > > I ran xfstests with 'xfs: validate acl count' and 'xfs: fix acl count
> > > > > validation in xfs_acl_from_disk()' applied to 3.1-stable.  It came out
> > > > > ok.  I'll get started on 2.6.32.
> > > > 
> > > > Thanks, how about the 3.0 release?
> > > 
> > > HCH would have given them a spin before he sent them to stable@.
> > 
> > You are right, sorry, for some reason I thought that was for 3.1, too
> > many different kernel trees at the moment :(
> 
> This should go into 3.0 and 3.1 stable, too.

This made 3.0, but unfortunately not 3.1, which is end-of-life.

-Ben

> And I think this one actually is simple enough that I don't need a QA
> run, so if you can just add it, please do.
> 
