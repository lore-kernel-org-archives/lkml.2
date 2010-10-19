Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab0JSPzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:55:54 -0400
Received: from kroah.org ([198.145.64.141]:59773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab0JSPzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:55:51 -0400
Date: Tue, 19 Oct 2010 08:53:24 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ruslan Pisarev <ruslanpisarev@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Gorskin Ilya <revent82@gmail.com>
Subject: Re: linux-next: manual merge of the staging-next tree with the
 v4l-dvb tree
Message-ID: <20101019155324.GJ4589@kroah.com>
References: <20101019171233.9f3e1dad.sfr@canb.auug.org.au>
 <20101019172331.89476ae0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019172331.89476ae0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 05:23:31PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Tue, 19 Oct 2010 17:12:33 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the staging-next tree got a conflict in
> > drivers/staging/cx25821/cx25821-audio-upstream.c between commit
> > d6a0215fc954bd16a21bad94a3292f080d9f6f04 ("[media] Staging: cx25821: fix
> > braces and space coding style issues") from the v4l-dvb tree and commit
> > bb59a4c539140592723e806e852ee171da0eb3eb ("Staging: cx25821: clenup
> > warnings found by checkpatch.pl tool in cx25821-audio-upstream.c and
> > cx25821-audio.h") from the staging-next tree.
> > 
> > Basically different versions of the same patch.  I fixed it up.
> 
> Fixed conflicts in drivers/staging/cx25821/cx25821-audio.h as well.

Thanks for doing this, I appreciate it.

greg k-h
