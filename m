Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab1HEPMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:12:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748Ab1HEPMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:12:06 -0400
Date: Fri, 5 Aug 2011 08:00:44 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 3.0.1
Message-ID: <20110805150044.GA17896@suse.de>
References: <20110805062136.GA2472@kroah.com>
 <4E3BAAC0.8080209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3BAAC0.8080209@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 10:33:04AM +0200, Jiri Slaby wrote:
> On 08/05/2011 08:21 AM, Greg KH wrote:
> > I'm announcing the release of the 3.0.1 kernel.
> > 
> > All users of the 3.0 kernel series must upgrade.
> > 
> > The updated 3.0.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-3.0.y.git
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-3.0.y.git;a=summary
> 
> It looks like you forgot to push :). Or some mirroring or alike problem?

My release process _requires_ me to push, in order to generate the
diffstat and patch that I send out, so yes, it's really there.

I think kernel.org is being a bit slow on the mirroring side right now,
so give it a bit of time.  I see it there now, perhaps it just needed a
little bit of sleep to catch up on things :)

thanks,

greg k-h
