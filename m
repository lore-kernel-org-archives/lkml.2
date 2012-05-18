Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762788Ab2EROUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:20:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48349 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964801Ab2EROUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:20:14 -0400
Date: Fri, 18 May 2012 16:20:12 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.5 for your for-3.5/drivers
 branch.
Message-ID: <20120518142011.GE6496@kernel.dk>
References: <20120511210517.GA29181@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511210517.GA29181@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11 2012, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.5
> 
> in your for-3.5/drivers branch. The changes in it are rather simple - cleaning
> up some code and adding proper mechanism to unload without leaking memory.
> 
>  drivers/block/xen-blkfront.c |   44 +++++++++++++++++++++++------------------
>  1 files changed, 25 insertions(+), 19 deletions(-)

Pulled in, thanks.

-- 
Jens Axboe

