Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab0K3VJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:09:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab0K3VJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:09:50 -0500
Date: Tue, 30 Nov 2010 16:09:38 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
Message-ID: <20101130210938.GF25668@bombadil.infradead.org>
References: <20101022012302.GA7487@havoc.gtf.org>
 <20101129180755.GK15818@bombadil.infradead.org>
 <4CF506A6.4020200@kernel.org>
 <20101130153839.GM15818@bombadil.infradead.org>
 <4CF52652.4030802@kernel.org>
 <20101130163150.GA25668@bombadil.infradead.org>
 <20101130175317.GB25668@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130175317.GB25668@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 12:53:17PM -0500, Kyle McMartin wrote:
> On Tue, Nov 30, 2010 at 11:31:50AM -0500, Kyle McMartin wrote:
> > On Tue, Nov 30, 2010 at 05:29:06PM +0100, Tejun Heo wrote:
> > > > Be happy to apply any debug patches, but I plan on replacing the drive
> > > > with a faster one at some point in the next few weeks.
> > > 
> > > Can you please apply the following patch and report the resulting
> > > kernel log?  You're on ahci, right?
> > > 
> > 
> > Yup, building now.
> > 
> 
> Ok, running it, I haven't seen the issue across three suspends... Will
> update when it inevitably happens.
> 

[10272.544858] ata1.00: ahci: internal command failure,
irq_stat=0x400001
[10272.544943] ata1.00: internal command failure: stat=0xef
ehi_desc="irq_stat 0x00400001, PHY RDY changed"
[10272.544951] ata1.00: failed to enable DIPM, Emask 0x100
[10272.544960] ata1: hard resetting link
[10273.004718] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[10273.006108] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[10273.006116] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[10273.006410] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[10273.006417] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[10273.009337] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
succeeded
[10273.009344] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[10273.009611] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES)
succeeded
[10273.009631] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[10273.010945] ata1.00: configured for UDMA/100
[10273.011206] ata1.00: ahci: internal command failure,
irq_stat=0x400001
[10273.011241] ata1.00: internal command failure: stat=0xef
ehi_desc="irq_stat 0x00400001, PHY RDY changed"
[10273.011247] ata1.00: failed to enable DIPM, Emask 0x100
[10273.011250] ata1: disabling LPM on the link
[10273.011255] ata1: limiting SATA link speed to 1.5 Gbps
[10273.011259] ata1.00: limiting speed to UDMA/100:PIO3

regards, Kyle
