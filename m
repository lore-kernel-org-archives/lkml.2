Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab1EZKWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:22:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:50637 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1EZKWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:22:20 -0400
Subject: Re: [PATCH 2/3] introduce intel_rapl driver
From: Peter Zijlstra <peterz@infradead.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com, "Brown, Len" <lenb@kernel.org>,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <1306403003.1200.41.camel@twins>
References: <1306398857.2207.157.camel@rui> <1306403003.1200.41.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 May 2011 12:21:39 +0200
Message-ID: <1306405299.1200.51.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 11:43 +0200, Peter Zijlstra wrote:
> > +     for(id = 0; id < RAPL_DOMAIN_MAX; id++)
> > +             if (rapl_domains[id].valid)
> > +                     perf_pmu_register(&(rapl_domains[id].pmu), rapl_domains[id].pmu.name, PERF_TYPE_SOFTWARE);
> 
> Uhm, hell no!, you get to use type = -1. 

Also, you don't need a struct pmu per domain.
