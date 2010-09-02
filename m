Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0IBULu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:11:50 -0400
Received: from kroah.org ([198.145.64.141]:57310 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab0IBULs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:11:48 -0400
Date: Thu, 2 Sep 2010 13:06:04 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, JiebingLi <jiebing.li@intel.com>,
        Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the usb tree with the trivial tree
Message-ID: <20100902200604.GC16897@kroah.com>
References: <20100902130118.add62d4a.sfr@canb.auug.org.au>
 <20100902032604.GB27598@kroah.com>
 <alpine.LNX.2.00.1009021633020.26813@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1009021633020.26813@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 04:34:36PM +0200, Jiri Kosina wrote:
> On Wed, 1 Sep 2010, Greg KH wrote:
> 
> > > Today's linux-next merge of the usb tree got a conflict in
> > > drivers/usb/gadget/langwell_udc.c between commit
> > > 7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
> > > unnecessary return's from void functions") from the trivial tree and
> > > commit 0f92bbacd2d1a26e8bf863d2cc05572df43bf7fb ("USB: langwell: USB
> > > Client driver code cleanup") from the usb tree.
> > > 
> > > Just context changes.  I fixed it up (see below) and can carry the fix
> > > while necessary.  Though, if that trivial tree commit was in the usb tree,
> > > the conflict could be resolved there ...
> > 
> > Joe, care to break this one change out and have me take it through the
> > usb tree?
> 
> Here it goes. I will revert this chunk in trivial tree for now.

Thanks, I've applied it to my tree now.

greg k-h
