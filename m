Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab2GXN1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:27:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab2GXN1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:27:45 -0400
Date: Tue, 24 Jul 2012 14:27:41 +0100
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Stable <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/34] Memory management performance backports for
 -stable V2
Message-ID: <20120724132741.GS9222@suse.de>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
 <1343109531.7412.47.camel@marge.simpson.net>
 <CAJd=RBC835W52nsXCqhM_4KR3CuLF9zijh3416LiJLybTuR_YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBC835W52nsXCqhM_4KR3CuLF9zijh3416LiJLybTuR_YA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 09:18:16PM +0800, Hillf Danton wrote:
> On Tue, Jul 24, 2012 at 1:58 PM, Mike Galbraith <efault@gmx.de> wrote:
> > FWIW, I'm all for performance backports.  They do have a downside though
> > (other than the risk of bugs slipping in, or triggering latent bugs).
> >
> > When the next enterprise kernel is built, marketeers ask for numbers to
> > make potential customers drool over, and you _can't produce any_ because
> > you wedged all the spiffy performance stuff into the crusty old kernel.
> >
> Well do your job please.
> 

I would suggest the user in question use the normal support channels for
resolving a potentially SLES-specific bug.

-- 
Mel Gorman
SUSE Labs
