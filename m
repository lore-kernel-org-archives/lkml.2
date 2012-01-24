Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab2AXQdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:33:08 -0500
Received: from verein.lst.de ([213.95.11.211]:57360 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab2AXQdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:33:04 -0500
Date: Tue, 24 Jan 2012 17:33:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Greg KH <gregkh@suse.de>
Cc: Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [41/42] xfs: validate acl count
Message-ID: <20120124163301.GA6077@lst.de>
References: <20120110215031.GA19398@kroah.com> <20120110215024.482323323@clark.kroah.org> <20120111074135.GA30829@lst.de> <20120111150021.GB23608@suse.de> <20120111150532.GL20739@sgi.com> <20120113161727.GB6519@sgi.com> <20120113181952.GA30393@suse.de> <20120113194218.GB14857@sgi.com> <20120113195206.GA16462@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113195206.GA16462@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 11:52:06AM -0800, Greg KH wrote:
> > > > I ran xfstests with 'xfs: validate acl count' and 'xfs: fix acl count
> > > > validation in xfs_acl_from_disk()' applied to 3.1-stable.  It came out
> > > > ok.  I'll get started on 2.6.32.
> > > 
> > > Thanks, how about the 3.0 release?
> > 
> > HCH would have given them a spin before he sent them to stable@.
> 
> You are right, sorry, for some reason I thought that was for 3.1, too
> many different kernel trees at the moment :(

This should go into 3.0 and 3.1 stable, too.

And I think this one actually is simple enough that I don't need a QA
run, so if you can just add it, please do.

