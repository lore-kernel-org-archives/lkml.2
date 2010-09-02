Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0IBD0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:26:42 -0400
Received: from kroah.org ([198.145.64.141]:59357 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0IBD0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:26:30 -0400
Date: Wed, 1 Sep 2010 20:26:04 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        JiebingLi <jiebing.li@intel.com>, Joe Perches <joe@perches.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: manual merge of the usb tree with the trivial tree
Message-ID: <20100902032604.GB27598@kroah.com>
References: <20100902130118.add62d4a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902130118.add62d4a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 01:01:18PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/gadget/langwell_udc.c between commit
> 7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
> unnecessary return's from void functions") from the trivial tree and
> commit 0f92bbacd2d1a26e8bf863d2cc05572df43bf7fb ("USB: langwell: USB
> Client driver code cleanup") from the usb tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix
> while necessary.  Though, if that trivial tree commit was in the usb tree,
> the conflict could be resolved there ...

Joe, care to break this one change out and have me take it through the
usb tree?

thanks,

greg k-h
