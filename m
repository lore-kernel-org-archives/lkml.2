Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345Ab0HENB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:01:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760332Ab0HENBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:01:22 -0400
Date: Thu, 5 Aug 2010 09:00:59 -0400
From: Neil Horman <nhorman@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linuxppc-dev@ozlabs.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        hbabu@us.ibm.com, paulus@samba.org, vgoyal@redhat.com
Subject: Re: [PATCH] powerpc: Add vmcoreinfo symbols to allow makdumpfile to
 filter core files properly
Message-ID: <20100805130059.GA2863@shamino.rdu.redhat.com>
References: <20100713134609.GA14514@hmsreliant.think-freely.org>
 <20100804144929.GA13970@hmsreliant.think-freely.org>
 <1280973866.1902.168.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280973866.1902.168.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 12:04:26PM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2010-08-04 at 10:49 -0400, Neil Horman wrote:
> > Ping yet again. Ben, This needs review/acceptance from you or Paul
> > Neil 
> 
> Isn't it already in powerpc-next about to be pulled by Linus ?
> 
Yes, there it is.  Apologies.  For whatever reason, I was looking on the main
branch of your tree.  It didn't occur to me to check your next branch.  Sorry.

> In general, I recommend you check the status of your patches on
> patchwork. I'm nagging Jeremy to add a feature so it emails the
> submitter when the patch status changes :-)
> 
Noted, I'll remember that.  Email from patchwork would be a nice feature. +1
from me. 

Thanks & Regards
Neil

> Cheers,
> Ben.
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
