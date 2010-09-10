Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0IJSP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:15:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56802 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab0IJSP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:15:26 -0400
Date: Fri, 10 Sep 2010 20:14:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andres Salomon <dilinger@queued.net>, devicetree-discuss@lists.ozlabs.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Mitch Bradley <wmb@laptop.org>, linux-kernel@vger.kernel.org,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: Re: [PATCH 2/2] x86: of: define irq functions to allow drivers/of/*
 to build on x86
Message-ID: <20100910181458.GA7243@elte.hu>
References: <20100910060151.6613e9c3@debxo>
 <20100910172538.GC11284@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910172538.GC11284@angua.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0365]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Grant Likely <grant.likely@secretlab.ca> wrote:

> On Fri, Sep 10, 2010 at 06:01:51AM -0700, Andres Salomon wrote:
> > 
> >  - Define a stub irq_create_of_mapping for x86 as a stop-gap solution until
> >    drivers/of/irq is further along.
> >  - Define irq_dispose_mapping for x86 to appease of_i2c.c
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> Applied to my test-devicetree branch.  I'll need an ack from the x86 
> maintainers before I put it into my -next branch.

The purpose of the patch is not clear to me. What does it do and why? 
The changelog says it's a stopgap measure - what exactly is the long 
term plan and how long will it take?

Thanks,

	Ingo
