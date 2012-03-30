Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab2C3Hrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:47:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35475 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758380Ab2C3Hrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:47:39 -0400
Date: Fri, 30 Mar 2012 09:47:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Trevor Turner <turn3r.tr3v0r@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: K7/Athlon Optimization Causes Build Fail on Kernel 3.3 i686
Message-ID: <20120330074734.GA22153@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Matt Fleming <matt.fleming@intel.com>,
	Trevor Turner <turn3r.tr3v0r@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CANYHJ6j6cxz47TGk8kdU58eau17Fi1K=fH2icmd=v19VjNggKw@mail.gmail.com>
 <20120328171059.GA7919@x1.osrc.amd.com>
 <4F7346BB.9020907@xenotime.net>
 <20120328172759.GC6765@x1.osrc.amd.com>
 <20120329074802.GA31955@liondog.tnic>
 <1333008855.4289.3.camel@mfleming-mobl1.ger.corp.intel.com>
 <20120329104822.GA17233@x1.osrc.amd.com>
 <4F74A9D8.1040808@zytor.com>
 <20120329204622.GA8655@liondog.tnic>
 <4F74CAEA.1010606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F74CAEA.1010606@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 01:49:46PM -0700, H. Peter Anvin wrote:
> That's the problem... it shouldn't use that.

Well, I guess those could be made to get replaced in with alternatives
upon boot so they resolve to some default memcpy et al during build
time...

> >> It should be possible to build with MK7 (which is an optimization
> >> option) and EFI (a functionality option) since they don't inherently
> >> conflict.  It just doesn't necessarily have to happen *right now*.
> > 
> > I know, technically it is doable, but do you see a K7 box with an EFI
> > firmware? I, at least, don't think so... :-)
> > 
> > Now, if you think that those optimizations could be used on other boxes
> > which could sport EFI, then that's a whole another question...
> > 
> 
> What I'm saying, mostly, is that this is indicative of a bigger bug.

Probably, but is it worth the trouble fixing it? I know, I know, this
could probably come back to bite us in other scenarios so we better fix
it right once and for all.

Let's leave it on the TODO list... (You know what happens to those items
:-))

-- 
Regards/Gruss,
    Boris.
