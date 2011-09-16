Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1IPSb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:31:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab1IPSbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:31:25 -0400
Date: Fri, 16 Sep 2011 14:31:13 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: andi@firstfloor.org, willy@meta-x.org, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: stable patch queues and submission
Message-ID: <20110916183113.GY10700@zod.bos.redhat.com>
References: <20110916181307.GW10700@zod.bos.redhat.com>
 <20110916182350.GA7315@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916182350.GA7315@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 08:23:50PM +0200, Greg KH wrote:
> > Hi All,
> > 
> > With kernel.org being down, the stable@kernel.org list is no longer
> > working.  This leaves me wondering if we should send patches directly to
> > the various stable tree maintainers with [stable] in the prefix and
> > linux-kernel CC'd, or if the stable queues are even being maintained
> > during the outage.
> 
> No, please do not, unless you need something "special", and even then,
> please cc: lkml and the developers so it's not lost.

Would "special" include patches that are backported for longterm
releases?

> > Does anyone have a preference or suggestion on how to continue stable
> > releases until the list comes back?  (I'm assuming 'wait' isn't really a
> > best all around option.)
> 
> Wait and continue to add the marking to your patches, my scripts are
> still running and pulling the patches out and they are going into the
> stable queue just fine.  The queue just isn't public at the moment due
> to kernel.org being out.

That's good to hear, and works for new patches with CC in the commit
log.  I should have been more clear in that I was more curious about
patches that are needed for longterm kernels but the upstream commits
don't directly apply.  They need to be backported and sent somewhere.

josh
