Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab2GYUnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 16:43:52 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33392 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2GYUnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 16:43:50 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jul 2012 16:43:50 EDT
Date: Wed, 25 Jul 2012 16:43:50 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
Message-ID: <20120725204350.GA20530@havoc.gtf.org>
References: <20120725203551.GA19762@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725203551.GA19762@havoc.gtf.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 04:35:51PM -0400, Jeff Garzik wrote:
> Please pull 641589bff714f39b33ef1d7f02eaa009f2993b64 from
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream
> 

Oh, I forgot to point out the merge commit, making my HEAD more recent
than might be expected.  There was a merge conflict and an API change
that needed to be dealt with, in order for your pull to be correct.

	Jeff



