Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab1ESRPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:15:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:44876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933640Ab1ESRPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:15:14 -0400
Date: Thu, 19 May 2011 10:12:27 -0700
From: Greg KH <gregkh@suse.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110519171227.GB22019@suse.de>
References: <20110518163142.GA3367@albatros>
 <20110518163951.GA24143@suse.de>
 <20110518170545.GA4435@albatros>
 <20110518191727.GA26741@suse.de>
 <20110519062622.GA4418@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519062622.GA4418@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:26:23AM +0400, Vasiliy Kulikov wrote:
> On Wed, May 18, 2011 at 12:17 -0700, Greg KH wrote:
> > > 1) *IF* another sensitive file with weird permissions is found, mount
> > > option is IMO the best temporary workaround.
> > 
> > Maybe, but fixing the file would be the obvious solution.
> 
> I mean for a sysadmin, not for a developer.

And I mean for the developer.

We have checks in place now to prevent this type of thing from happening
again in the future.  If it does, and it might, we will fix it, it's
that simple.

> What do you mean by "breaking system"?  Root is able to chmod
> and chown sysfs files already, he may do "chmod -R" or similar.
> I suggest sane, race free way to globally restrict permissions *IF* root
> wants it.

If root wants it, they can do this today with a simple 1 line bash
command, so I don't see the issue.

> Here https://lkml.org/lkml/2011/2/25/300 you, not aware of usefull
> applications of world-writable debugfs file, agreeded to statically
> restrict permissions of all files.  I suggest more flexible and
> configurable in runtime solution.  It doesn't break anything - default
> behaviour doesn't differ from current one.  What has changed in your
> mind since 2/25?

That's debugfs, not sysfs, which we are talking about here, right?

thanks,

greg k-h
