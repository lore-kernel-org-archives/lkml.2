Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1EGIvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 04:51:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1EGIvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 04:51:42 -0400
Date: Sat, 7 May 2011 04:46:57 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Jim Schutt <jaschut@sandia.gov>, James Bottomley <James.Bottomley@suse.de>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [stable] [patch 04/38] [SCSI] put stricter
 guards on queue dead checks
Message-ID: <20110507044657.171b0573@katamari>
In-Reply-To: <20110506161754.GA31472@kroah.com>
References: <20110506001207.658271797@clark.kroah.org>
	<4DC40B94.9060903@sandia.gov>
	<20110506161754.GA31472@kroah.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011 09:17:54 -0700
Greg KH <greg@kroah.com> wrote:

> On Fri, May 06, 2011 at 08:54:12AM -0600, Jim Schutt wrote:
> > Hi Greg,
> > 
> > Greg KH wrote:
> > >2.6.38-stable review patch.  If anyone has any objections, please let us know.
> > 
> > You probably don't want to add this patch to stable kernels
> > until commit c055f5b2614b4f from
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6
> > shows up in Linus' tree.
> > 
> > See details in http://www.spinics.net/lists/kernel/msg1181665.html.
> 
> James, do you agree with this?
> 

That patch is upstream in Linus's tree now:

commit c055f5b2614b4f758ae6cc86733f31fa4c2c5844
"[SCSI] fix oops in scsi_run_queue()"

So you can add that instead of dropping Patch 04.
