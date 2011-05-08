Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1EHTRx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 15:17:53 -0400
Received: from kroah.org ([198.145.64.141]:59014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab1EHTRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 15:17:51 -0400
Date: Sun, 8 May 2011 12:18:53 -0700
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 3/4] EDAC, MCE, AMD: Add hw_inject and cpu sysfs attrs
Message-ID: <20110508191853.GA10273@kroah.com>
References: <1304614176-7063-1-git-send-email-bp@amd64.org>
 <1304614176-7063-4-git-send-email-bp@amd64.org>
 <20110508164054.GA4199@kroah.com>
 <20110508184911.GA511@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110508184911.GA511@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 08:49:11PM +0200, Borislav Petkov wrote:
> On Sun, May 08, 2011 at 12:40:54PM -0400, Greg KH wrote:
> > On Thu, May 05, 2011 at 06:49:35PM +0200, Borislav Petkov wrote:
> > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > > Add sysfs handlers for the 'hw_inject' and 'cpu' attrs.
> > 
> > You forgot to add the proper Documentation/ABI/ files for these new
> > sysfs files.  Please do that.
> 
> Yeah, so those sprang up as a testing module and the final goal is to
> have all injection done through perf events but it could also be prudent
> to keep those as a fallback alternative.
> 
> I'm thinking something like
> Documentation/ABI/testing/sysfs-devices-system-edac but looking
> at Documentation/ABI/README and reading the "testing/" category
> description, I don't think it applies to those interfaces just yet for
> the simple reason that they're still changing and I wouldn't want to
> cast them in stone now.
> 
> Can we add them to a "unstable" category instead or maybe delay making
> the ABI description for now?

No.  If you add sysfs files to the kernel, you had better be sure that
they are correct and are what you want to be doing.  Otherwise, don't
add them.

As you really want to do this through perf, just do it through perf.
Please don't create a user/kernel api that you are not going to want to
use in the end.

thanks,

greg k-h
