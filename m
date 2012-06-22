Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab2FVP1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181Ab2FVP1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:27:37 -0400
Date: Fri, 22 Jun 2012 11:27:27 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joe Thornber <ejt@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm thin: reinstate missing mempool_free in cell_release_singleton
Message-ID: <20120622152727.GA4196@redhat.com>
References: <20120330195801.GA31806@kroah.com>
 <20120330194856.784259750@linuxfoundation.org>
 <20120622145947.GA4089@redhat.com>
 <20120622151650.GA5785@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622151650.GA5785@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22 2012 at 11:16am -0400,
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Jun 22, 2012 at 10:59:48AM -0400, Mike Snitzer wrote:
> > Hi Greg,
> > 
> > 3.3-stable pulled in upstream commit
> > 6f94a4c45a6f744383f9f695dde019998db3df55 (dm thin: fix stacked bi_next usage)
> > 
> > But later in the 3.4 development window it was determined that that
> > commit introduced a significant leak.  The following upstream commit
> > fixes it (but unfortunately didn't cc: stable).
> 
> 3.3 is end-of-life, so there's not much I can do with the 3.3-stable
> tree anymore, sorry.  If there's any other tree I should apply this to
> that is active (i.e. 3.0 or 3.4), please let me know.

OK, no other active stable tree is affected, thanks.
