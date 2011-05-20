Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab1ETNxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:53:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:50140 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab1ETNxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:53:30 -0400
Date: Fri, 20 May 2011 06:54:24 -0700
From: Greg KH <gregkh@suse.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110520135424.GA10878@suse.de>
References: <20110518163142.GA3367@albatros>
 <20110518163951.GA24143@suse.de>
 <20110518170545.GA4435@albatros>
 <20110518191727.GA26741@suse.de>
 <20110519062622.GA4418@albatros>
 <20110519171227.GB22019@suse.de>
 <20110520095920.GA4489@albatros>
 <20110520133044.GC10225@suse.de>
 <20110520133451.GA8112@albatros>
 <20110520133615.GB8112@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520133615.GB8112@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 05:36:15PM +0400, Vasiliy Kulikov wrote:
> On Fri, May 20, 2011 at 17:34 +0400, Vasiliy Kulikov wrote:
> > On Fri, May 20, 2011 at 06:30 -0700, Greg KH wrote:
> > > > Correct.  So, if I understood you, you are OK with adding mount options
> > > > for debugfs, but not sysfs, right?  What is the difference between them
> > > > in sense of permissions?
> > > 
> > > debugfs is "there are no rules", so changing the permissions on it
> > > shouldn't break anything as no userspace tools "should" rely on it.  Now
> > > that really isn't true (see the perf stuff), but overall it is, so I
> > > don't worry about changing things there as much as sysfs, which has
> > > hundreds of tools relying on it.
> > 
> > What would break if the default behaviour is not changed?
> 
> Err... sorry, s/would break/would it break/

That's the question for you, we would be changing the kernel/user api
here, and odds are, something will break.

thansk,

greg k-h
