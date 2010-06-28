Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0F1Usb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:48:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36282 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0F1Us3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:48:29 -0400
Date: Mon, 28 Jun 2010 21:48:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Robert Hancock <hancockrwd@gmail.com>, lenb@kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
Message-ID: <20100628204820.GA32503@srcf.ucam.org>
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz> <4C27E965.80508@gmail.com> <4C283D84.6080504@suse.cz> <20100628171410.GA27367@srcf.ucam.org> <4C290245.2040001@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C290245.2040001@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 10:12:53PM +0200, Jiri Slaby wrote:
> On 06/28/2010 07:14 PM, Matthew Garrett wrote:
> > http://www-07.ibm.com/hk/products/pos/300/specs.html indicates that 
> > Windows is supported on this hardware. It would be good to verify that 
> > it also fails before we try a model-specific quirk.
> 
> It would be good for what? I don't see the point, DSDT is broken on that
> machine and the patch works this around. Why do we need testruns from
> Windows? And why you think Windows will fail anyway, they can very have
> the pretty same quirk there.

I can guarantee to you that a generic Windows install does not have a 
quirk for an IBM PoS system released years after that CD was pressed. 
The relevance is that if Windows works without a quirk, then somewhere 
our behaviour diverges from that of Windows and it's likely that other 
machines are also hit by the same issue. Users of those systems may not 
have a support contract with a commercial Linux vendor and may just 
decide to use Windows instead, so there's an incentive for us to 
determine if that's the case and fix Linux's behaviour to match Windows 
rather than to just quirk over it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
