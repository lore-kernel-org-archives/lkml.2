Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab1BCLaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 06:30:14 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:39630 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab1BCLaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 06:30:12 -0500
Date: Thu, 3 Feb 2011 12:31:17 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] AMD microcode fixes
Message-ID: <20110203113117.GA24755@aftab>
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

On Thu, Feb 03, 2011 at 05:35:48AM -0500, Ingo Molnar wrote:
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

Yeah, I've sent him the chunk as two patches already and they're
going to go over his tree. I'll redo the pull request without the
<drivers/base/sys.c> portion maybe today.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
