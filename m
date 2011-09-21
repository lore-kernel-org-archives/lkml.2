Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1IUPfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:35:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28285 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1IUPft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:35:49 -0400
Date: Wed, 21 Sep 2011 11:35:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        lidongyang@novell.com, joe.jin@oracle.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.2 - blkback and blkfront
 patches for 3.2
Message-ID: <20110921153537.GB1512@phenom.oracle.com>
References: <20110921150955.GH541@phenom.oracle.com>
 <20110921151732.GA28043@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921151732.GA28043@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4E7A044D.0204,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 11:17:32AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 21, 2011 at 11:09:55AM -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Jens,
> > 
> > Please pull the following git tree in your 3.2 drivers tree:
> > 
> >  git pull git://oss.oracle.com/git/kwilk/xen.git stable/for-jens-3.2
> > 
> > which has an exciting new feature - the discard ('feature-discard')
> > aka TRIM/UNMAP. Now they can be passed from the guest to the backend.
> 
> What is the design of them?  Do you provide the 'discard zeroes data'
> flag (mandatory for any kind of relible operation) and 'discard

Hmm, not sure what that is. Is that REQ_SECURE, err BLKDEV_DISCARD_SECURE?
If so then not in this patchset - but it does not seem like it would dificult
to add that in? Li, what do you think?

> granularity / alignment' tunables (very useful)?

The discard granularity/alignment are certainly there. But they are just
one way (backend tells the guest what they are). Should they be
more tunable (frontend tells the backend what the values ought to be?)

Li, did I miss anything in my response?
