Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab0JELk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:40:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58467 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0JELkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:40:55 -0400
Date: Tue, 5 Oct 2010 12:40:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
        linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3
	boot hang
Message-ID: <20101005114047.GA29495@srcf.ucam.org>
References: <alpine.LFD.2.00.1009242122390.8641@localhost.localdomain> <20100927135735.GA856@srcf.ucam.org> <alpine.LFD.2.00.1009301810380.7033@localhost.localdomain> <20100930222946.GB23084@srcf.ucam.org> <alpine.LFD.2.00.1010050104450.23209@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010050104450.23209@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 01:06:15AM -0400, Len Brown wrote:
> > > we check (and clear) that bit only if the acpi tables
> > > tell us to do so.
> > 
> > Do the tables tell us to do so on this platform?
> 
> In this configuration, yes, otherwise acpi_idle
> would have failed in exactly the same way.

So why is intel_idle not paying attention to what the platform is 
requesting?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
