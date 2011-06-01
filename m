Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab1FAPP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:15:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58350 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab1FAPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:15:27 -0400
Date: Wed, 1 Jun 2011 11:15:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [git pull v3.0-rc1] What branch to base fixes for v3.0-rc1 for
 block system?
Message-ID: <20110601151513.GB32270@dumpdata.com>
References: <20110531191039.GA5269@dumpdata.com>
 <4DE54097.7060000@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE54097.7060000@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DE6578D.0062:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 09:25:11PM +0200, Jens Axboe wrote:
> On 2011-05-31 21:10, Konrad Rzeszutek Wilk wrote:
> > Hey Jens,
> > 
> > I've got two tiny fixes for the xen-blkback (see below):
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git for-jens/xen-blkback.fixes
> > 
> > and they are based on for-2.6.40/drivers branch. Is that the way you
> > prefer to pull patches from sub-trees? Or should I rebase it on 3.0-rc1?
> > Or should send bug-fixes just directly to Linus?
> 
> Once I send off the big initial merges which are in the version named
> for-2.6.40/xx branches, anything after that should just be based on my
> for-linus branch. That's what I use for post-rc1 merges with Linus.
> 
> But the only real sticking point is that your branch should not contain
> something that I don't have in my for-linus. And you don't right now, so
> I just pulled it :-)

Can you repull that branch please? I've rebased it on for-linus branch
and fixed the embarrassing compilation issue it had..
