Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab2AMQRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 11:17:32 -0500
Received: from relay3.sgi.com ([192.48.152.1]:54265 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755602Ab2AMQR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 11:17:29 -0500
Date: Fri, 13 Jan 2012 10:17:27 -0600
From: Ben Myers <bpm@sgi.com>
To: Greg KH <gregkh@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [41/42] xfs: validate acl count
Message-ID: <20120113161727.GB6519@sgi.com>
References: <20120110215031.GA19398@kroah.com> <20120110215024.482323323@clark.kroah.org> <20120111074135.GA30829@lst.de> <20120111150021.GB23608@suse.de> <20120111150532.GL20739@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111150532.GL20739@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

On Wed, Jan 11, 2012 at 09:05:32AM -0600, Ben Myers wrote:
> Hi Christoph & Greg,
> 
> On Wed, Jan 11, 2012 at 07:00:21AM -0800, Greg KH wrote:
> > On Wed, Jan 11, 2012 at 08:41:35AM +0100, Christoph Hellwig wrote:
> > > On Tue, Jan 10, 2012 at 01:48:51PM -0800, Greg KH wrote:
> > > > 3.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > Just curious, how well tested are all the patches on 2.6.32 and 3.1 hat I only
> > > submitted for 3.0?  I'd really prefer if they at least get an xfstest run
> > > before they get sent out to the world.
> > 
> > I took these patches on my own as they were reported to fix a public
> > vulnerability which was assigned a CVE.  They applied with no fuzz and
> > "looked correct" so I applied them on my own.
> > 
> > If I shouldn't have, please let me know and I'll drop them.
> > 
> > Otherwise, a nice run of xfstest by someone would be appreciated.
> 
> I have a 3.1 test rig and will get this done today, then I'll go after
> 2.6.32.

I ran xfstests with 'xfs: validate acl count' and 'xfs: fix acl count
validation in xfs_acl_from_disk()' applied to 3.1-stable.  It came out
ok.  I'll get started on 2.6.32.

-Ben
