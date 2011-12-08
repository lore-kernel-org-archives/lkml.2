Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab1LHBg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:36:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab1LHBgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:36:55 -0500
Date: Wed, 7 Dec 2011 17:36:40 -0800
From: Chris Wright <chrisw@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Wright <chrisw@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Gibson <dwg@au1.ibm.com>, joerg.roedel@amd.com,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, agraf@suse.de, scottwood@freescale.com,
        B08248@freescale.com
Subject: Re: RFC: Device isolation infrastructure
Message-ID: <20111208013640.GK2395@x200.localdomain>
References: <20111207035816.GC7631@truffala.fritz.box>
 <1323240402.2182.241.camel@bling.home>
 <20111207142201.GA5696@truffala.fritz.box>
 <1323287120.15059.63.camel@bling.home>
 <1323301293.12793.16.camel@pasglop>
 <20111208001645.GJ2395@x200.localdomain>
 <1323307969.12793.17.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323307969.12793.17.camel@pasglop>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt (benh@kernel.crashing.org) wrote:
> On Wed, 2011-12-07 at 16:16 -0800, Chris Wright wrote:
> > Since users will want to drive devices, not groups, how would you
> > enumerate and expose devices here if the user visible construct
> > exposed is groups?
> 
> We do expose the individual devices in the group, which can then be used
> for things like mmap'ing of BARs etc...

Right, one of the areas that got sticky before, which is why I wondered
how you'd manage it.

> However, at least, the ownership transition is done on a whole group
> basis

Yeah, that makes sense.

thanks,
-chris
