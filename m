Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab1BCPaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:30:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:45441 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab1BCPaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:30:22 -0500
Date: Thu, 3 Feb 2011 07:29:11 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] AMD microcode fixes
Message-ID: <20110203152911.GA32399@suse.de>
References: <20110131133024.GC32230@aftab>
 <20110203103548.GA14601@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203103548.GA14601@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:35:48AM +0100, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > There's one out-of-tree change to <drivers/base/sys.c> which Greg hasn't
> > explicitly acked yet but judging by his silence he has nothing against
> > it :).
> 
> Hm, the drivers/base/sys.c portion is not particularly small:
> 
> >  arch/x86/kernel/microcode_amd.c  |  142 ++++++++++++++++++--------------------
> >  arch/x86/kernel/microcode_core.c |    6 +-
> >  drivers/base/sys.c               |   65 ++++++++++++-----
> >  3 files changed, 118 insertions(+), 95 deletions(-)
> 
> So i'd really like to have an Acked-by from Greg.
> 
> Greg, what's your take on this? The patches are here:

My take was that I NAKed it, Borislav was going to redo this series
without this patch in it as it was not necessary for his microcode
changes.

thanks,

greg k-h
