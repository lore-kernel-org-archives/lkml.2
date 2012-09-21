Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab2IUV2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:28:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab2IUV2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:28:33 -0400
Date: Fri, 21 Sep 2012 15:28:49 -0600
From: John Jolly <jjolly@suse.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, venkat.x.venkatsubra@oracle.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] rds: Error on offset mismatch if not loopback
Message-ID: <20120921212849.GI14393@linux-tkdk.sfcn.org>
References: <20120920071134.GF14393@linux-tkdk.sfcn.org>
 <20120921.132045.951559071646755065.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921.132045.951559071646755065.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 01:20:45PM -0400, David Miller wrote:
> From: John Jolly <jjolly@suse.com>
> Date: Thu, 20 Sep 2012 01:11:34 -0600
> 
> > Attempting an rds connection from the IP address of an IPoIB interface
> > to itself causes a kernel panic due to a BUG_ON() being triggered. Making
> > the test less strict allows rds-ping to work without crashing the machine.
> > 
> > A local unprivileged user could use this flaw to crash the sytem.
> 
> Please read Documentation/SubmittingPatches to learn how to properly
> submit a change, in particular your patch submission was missing a
> proper signoff.

Thanks for catching that. Resubmitting with proper signoff.

> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
