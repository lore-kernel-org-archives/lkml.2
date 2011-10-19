Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1JSUDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 16:03:17 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49721 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab1JSUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 16:03:12 -0400
X-Sasl-enc: TDAC2js91cHEVoz1GHDq4tEVklfzNIaDQlsSXrEyyowQ 1319054591
Date: Wed, 19 Oct 2011 13:01:45 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Josh Boyer <jwboyer@gmail.com>, Dave Jones <davej@redhat.com>,
        Simon Kirby <sim@hostway.ca>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Patch Upstream: cputimer: Cure lock inversion
Message-ID: <20111019200145.GB16108@kroah.com>
References: <20111019153914.9153A2188@git.kroah.org>
 <20111019154910.GA9361@kroah.com>
 <CA+5PVA7-9Vyy+16+wXPCPEce3v4z8PxwW3WfGGBDzobAC-_-bQ@mail.gmail.com>
 <20111019160037.GA11087@kroah.com>
 <CA+5PVA6GnscQTRbv=r0NZvU4jNGwnr64OG6qAZvGhnjSAGCgrA@mail.gmail.com>
 <1319041156.2593.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319041156.2593.1.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 06:19:16PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-10-19 at 12:03 -0400, Josh Boyer wrote:
> > > Ugh, I'll go dig, but help would be appreciated...
> > 
> > My guess is they meant d670ec13178d0fd868
> > 
> Your guess is right, no idea how I messed that up, my git tree contains
> both commits and they're similar but different version of the same
> patch.

No problem, just got confused here,

greg k-h
