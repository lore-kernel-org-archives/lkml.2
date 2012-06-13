Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2FMTTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:19:22 -0400
Received: from [85.118.1.10] ([85.118.1.10]:38439 "EHLO casper.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab2FMTTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:19:21 -0400
Date: Wed, 13 Jun 2012 21:19:13 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        wdauchy@gmail.com, stefano.stabellini@eu.citrix.com, jbeulich@suse.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.5 for 3.5-rc2..
Message-ID: <20120613191913.GD8230@kernel.dk>
References: <20120612123524.GA559@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612123524.GA559@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12 2012, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please pull:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.5
> 
> it has two critical fixes to deal with 32/64 guest/host combinations
> when sending DISCARD commands. They weren't properly sent resulting
> in the guest crashing (https://bugzilla.redhat.com/show_bug.cgi?id=824641)
> The fix is in the backend (blkback) and the frontend has some extra
> WARN_ON added to diagnose similar issues like this in the future.
> 
> Or if you prefer - I can stick those two patches in my tree and
> send them to Linus in my git pull this Friday with your Ack-ed by tag.

Thanks Konrad, pulled.

-- 
Jens Axboe

