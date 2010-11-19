Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0KSPXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:23:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab0KSPXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:23:47 -0500
Date: Fri, 19 Nov 2010 10:23:30 -0500
From: Jason Baron <jbaron@redhat.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101119152330.GA2890@redhat.com>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <1290041086-sup-5766@au1.ibm.com> <20101118151141.GA3368@redhat.com> <1290133618-sup-2278@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290133618-sup-2278@au1.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 01:32:08PM +1100, Ian Munsie wrote:
> Hi Jason,
> 
> I'm adding Avantika to the CC list as she recently contacted me
> regarding syscall tracepoints on PowerPC.
> 
> Excerpts from Jason Baron's message of Fri Nov 19 02:11:42 +1100 2010:
> > I was wondering what the status of those patches were...last I remember
> > they looked pretty good to me...I'd be more than happy to help review
> > those.
> 
> Yeah there isn't much left to do on them - the main delay has just been
> finding some time to work on them.
> 
> I did want to revisit the naming of the events and the subtle
> differences for syscalls with a single implementation for both the
> native and compat versions versus those that have separate
> implementations - I don't want userspace to have to care about that
> distinction.
> 
> I recall there were a few comments on some of your patches in the series
> - if I rebase the patches on the current tip tree and publish the tree
> somewhere would you be willing to take a look at those?
> 

sure. the remaining issue was to combine the enabled/disabled flags into
the 'int nb_args' field since we are only using 3 bits of it. that
shouldn't be too bad...

thanks,

-Jason

