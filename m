Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1ELN1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:27:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63513 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab1ELN1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:27:24 -0400
Date: Thu, 12 May 2011 09:27:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] (xen) stable/blkfront for 2.6.40
Message-ID: <20110512132715.GC11649@dumpdata.com>
References: <20110510171107.GA939@dumpdata.com>
 <4DCACD25.6060107@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCACD25.6060107@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DCBE039.000F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 07:53:41PM +0200, Jens Axboe wrote:
> On 2011-05-10 19:11, Konrad Rzeszutek Wilk wrote:
> > Hey Jens,
> > 
> > Please pull:
> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/blkfront
> > 
> > which has changes since git commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58
> > Linus Torvalds (1):
> >     Linux 2.6.39-rc5
> > 
> > The git commit includes a bug-fix, and a set of patches to allow the blkfront
> > driver to use 'feature-flush-cache' feature. The 'flush-cache' is basically
> > the equivalent of the new REQ_FLUSH command (the old 'feature-barrier' is
> > still present in the driver in case the backend supports that).
> > 
> > If you prefer for me to ask Linus to pull this git tree since it includes
> > a patch to the include/xen/interface/.. directory - I can do that as long as
> > you are OK with that.
> 
> I don't mind pulling it directly, that's fine. But you are based on
> 2.6.39-rc5, you should be based on for-2.6.40/drivers (or core) instead.

Easily fixed:
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git for-jens/xen-blkfront

is now based on your for-2.6.40/drivers.

> If I pull the above, I end up getting all the changes from rc4..rc5 as
> well.

Ah, OK. Will make sure to check your for-2.6.40 in the future. Thanks!
