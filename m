Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab1LHBdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:33:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:35472 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717Ab1LHBde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:33:34 -0500
Message-ID: <1323307969.12793.17.camel@pasglop>
Subject: Re: RFC: Device isolation infrastructure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Chris Wright <chrisw@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        David Gibson <dwg@au1.ibm.com>, joerg.roedel@amd.com,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, agraf@suse.de, scottwood@freescale.com,
        B08248@freescale.com
Date: Thu, 08 Dec 2011 12:32:49 +1100
In-Reply-To: <20111208001645.GJ2395@x200.localdomain>
References: <20111207035816.GC7631@truffala.fritz.box>
	 <1323240402.2182.241.camel@bling.home>
	 <20111207142201.GA5696@truffala.fritz.box>
	 <1323287120.15059.63.camel@bling.home> <1323301293.12793.16.camel@pasglop>
	 <20111208001645.GJ2395@x200.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 16:16 -0800, Chris Wright wrote:
> Since users will want to drive devices, not groups, how would you
> enumerate and expose devices here if the user visible construct
> exposed is groups?

We do expose the individual devices in the group, which can then be used
for things like mmap'ing of BARs etc...

However, at least, the ownership transition is done on a whole group
basis

Cheers,
Ben.

