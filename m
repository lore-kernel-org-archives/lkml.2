Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab1E3O1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:27:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126Ab1E3O1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:27:34 -0400
Date: Mon, 30 May 2011 22:28:28 +0800
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@linux.intel.com,
        tony.luck@intel.com, stable@kernel.org
Subject: Re: Patch "x86, efi: Retain boot service code until after switching
 to" has been added to the 2.6.39-stable tree
Message-ID: <20110530142828.GA22750@suse.de>
References: <13067284712957@kroah.org>
 <201105301552.57712.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105301552.57712.s.L-H@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 03:52:55PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Monday 30 May 2011, gregkh@suse.de wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     x86, efi: Retain boot service code until after switching to
> > 
> > to the 2.6.39-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      x86-efi-retain-boot-service-code-until-after-switching-to.patch
> > and it can be found in the queue-2.6.39 subdirectory.
> 
> The -stable backport of this upstream commit introduces a syntax error,
> see below.

Thanks, I've fixed it now.

Didn't catch it here as all I have is a i386 slow laptop to build on at
the moment :(

greg k-h
