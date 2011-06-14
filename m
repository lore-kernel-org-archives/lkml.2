Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab1FNIBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:01:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:42226 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022Ab1FNIBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:01:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,363,1304319600"; 
   d="scan'208";a="15953218"
Date: Tue, 14 Jun 2011 10:01:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Margarita Olaya <magi@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca, "Girdwood, Liam" <lrg@ti.com>
Subject: Re: [PATCHv5 0/4]Initial support for TPS65912 PMIC
Message-ID: <20110614080137.GB2880@sortiz-mobl>
References: <BANLkTikye+vb1WJ08rup23=APxuOENK+Tw@mail.gmail.com>
 <BANLkTin+E1mbMFURSADKC3bm5BeeczHW7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin+E1mbMFURSADKC3bm5BeeczHW7A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Margarita,

On Mon, Jun 13, 2011 at 04:56:54PM -0500, Margarita Olaya wrote:
> Hi Samuel,
> 
> On Thu, Jun 9, 2011 at 2:49 PM, Margarita Olaya <magi@slimlogic.co.uk> wrote:
> > Hi,
> >
> > This is the initial version of the TPS65912 PMIC, a power management IC
> > for multimedia products.
> >
> > The tps65912 consists of 4 DCDCs and 10 LDOs, that are able to supply
> > voltage to main processor and other components. The chip includes a
> > GPIO module.
> >
> 
> All the patches have the ack, are you going to take them via MFD tree?
I will, no worries. I haven't found time to go through my MFD backlog yet.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
