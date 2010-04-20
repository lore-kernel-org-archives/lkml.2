Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0DTIFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 04:05:41 -0400
Received: from relay3.sgi.com ([192.48.152.1]:54384 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753597Ab0DTIFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 04:05:38 -0400
Date: Tue, 20 Apr 2010 03:05:37 -0500
From: Robin Holt <holt@sgi.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [GIT PULL] percpu for v2.6.32
Message-ID: <20100420080537.GP4920@sgi.com>
References: <4AAF411C.2040501@kernel.org>
 <alpine.DEB.1.10.0909151510010.3340@V090114053VZO-1>
 <4AAFE9B2.1030006@kernel.org>
 <alpine.DEB.1.10.0909151531490.3340@V090114053VZO-1>
 <4AAFEF48.8000607@sgi.com>
 <4AB03F23.7080605@kernel.org>
 <20100420075643.GO4920@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420075643.GO4920@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course, you could ignore this from 7 months ago if you like.  I had
resorted my lkml mailbox and then got myself confused.  The offer does
stand if you still need access.

Thanks,
Robin

On Tue, Apr 20, 2010 at 02:56:43AM -0500, Robin Holt wrote:
> Mike, if you can not find one, let me know.  I would try the benchmarkers.
> IIRC, they may have those already ready to go.
> 
> Tejun, I have an SGI Prism at home that is normally powered off.
> I could power that up, get you set up to access it, and let you lose.
> There are basic commands for using the L2 to power on and off and to
> reset.  I think it is currently set up with some bad dimms so I would
> need to remove those before this evolution.
> 
> I wouldn't mind helping with the patches, but I have no time right
> now.
> 
> Thanks,
> Robin
> 
> 
> On Wed, Sep 16, 2009 at 10:28:03AM +0900, Tejun Heo wrote:
> > Hello,
> > 
> > Mike Travis wrote:
> > > We certainly have some in our labs but I'm not sure of one that's
> > > externally accessible.  If there's a pre-defined test you'd like to
> > > run, you can send me the details.  Otherwise, I'll check around and
> > > see if there's a system available remotely.
> > 
> > The proposed broken patch is in the following thread.  It works on ski
> > emulator but ski doesn't support SMP, so...
> > 
> >  http://thread.gmane.org/gmane.linux.kernel.cross-arch/4132
> > 
> > The patch shouldn't be too broken.  It probably needs slight tweaks
> > here and there.  Just testing and providing logs would be helpful
> > enough.
> > 
> > Thanks.
> > 
> > -- 
> > tejun
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
