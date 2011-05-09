Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1EIUoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:44:54 -0400
Received: from kroah.org ([198.145.64.141]:42130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab1EIUoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:44:25 -0400
Date: Mon, 9 May 2011 13:43:10 -0700
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Jim Schutt <jaschut@sandia.gov>,
        linux-kernel@vger.kernel.org, stable-review@kernel.org,
        James Bottomley <James.Bottomley@suse.de>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [patch 04/38] [SCSI] put stricter
 guards on queue dead checks
Message-ID: <20110509204310.GC1432@kroah.com>
References: <20110506001207.658271797@clark.kroah.org>
 <4DC40B94.9060903@sandia.gov>
 <20110506161754.GA31472@kroah.com>
 <20110507044657.171b0573@katamari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110507044657.171b0573@katamari>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 04:46:57AM -0400, Chuck Ebbert wrote:
> On Fri, 6 May 2011 09:17:54 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, May 06, 2011 at 08:54:12AM -0600, Jim Schutt wrote:
> > > Hi Greg,
> > > 
> > > Greg KH wrote:
> > > >2.6.38-stable review patch.  If anyone has any objections, please let us know.
> > > 
> > > You probably don't want to add this patch to stable kernels
> > > until commit c055f5b2614b4f from
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6
> > > shows up in Linus' tree.
> > > 
> > > See details in http://www.spinics.net/lists/kernel/msg1181665.html.
> > 
> > James, do you agree with this?
> > 
> 
> That patch is upstream in Linus's tree now:
> 
> commit c055f5b2614b4f758ae6cc86733f31fa4c2c5844
> "[SCSI] fix oops in scsi_run_queue()"
> 
> So you can add that instead of dropping Patch 04.

Now queued up, thanks.

greg k-h
