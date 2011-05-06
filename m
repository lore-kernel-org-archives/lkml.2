Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1EFX5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 19:57:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:50074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab1EFX5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 19:57:12 -0400
Date: Fri, 6 May 2011 16:55:44 -0700
From: Greg KH <gregkh@suse.de>
To: Javier =?iso-8859-1?Q?Mu=F1oz?= <jmunhoz@igalia.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: sm7xx: Use kernel framebuffer mode setting
Message-ID: <20110506235544.GC22803@suse.de>
References: <1304702696-9403-1-git-send-email-jmunhoz@igalia.com>
 <20110506212207.GA3222@kroah.com>
 <4DC475A9.8070701@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DC475A9.8070701@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 12:26:49AM +0200, Javier Muñoz wrote:
> On 05/06/2011 11:22 PM, Greg KH wrote:
> >On Fri, May 06, 2011 at 07:24:56PM +0200, Javier M. Mellid wrote:
> >>This patch implements dynamic framebuffer mode setting.
> >>
> >>Previous code works with mode setting in a hard code way. Previous hard
> >>code configuration is used as default configuration if dynamic mode
> >>setting or boot mode setting (via sm712vga_setup) is not used.
> >>
> >>Tested with SM712 supporting 1024x600x16 as default hardware resolution.
> >>
> >>Changes:
> >>
> >>- Implement fb_check_var and fb_set_par callbacks
> >>- Remove __maybe_unused decorator in function being used (sm712vga_setup)
> >>- Minor cleanup on initialization structs related with mode settings
> >>- Updated author copyright
> >>- Updated TODO file
> >>
> >>Signed-off-by: Javier M. Mellid<jmunhoz@igalia.com>
> >>---
> >>  drivers/staging/sm7xx/TODO     |    1 -
> >
> >This applies with fuzz, this leads me to believe that you didn't test
> >this on the latest linux-next tree, right?
> >
> >What did you make this patch against?
> 
> Sorry, I didn't know. I made this patch against
> linux-2.6 (bfd412db9e7b0d8f7b9c09d12d07aa2ac785f1d0) as I did with
> previous patches.
> 
> Testing was about creating, applying, compiling and running patch
> with kernel built from linux-2.6
> 
> Do you need a new patch against linux-next's master? I can redo this patch.

Yes, please always make patches against linux-next as it includes any
other pending patches that are in my tree.

thanks,

greg k-h
