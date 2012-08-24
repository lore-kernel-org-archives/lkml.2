Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab2HXMxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 08:53:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41074 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356Ab2HXMxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 08:53:05 -0400
Date: Fri, 24 Aug 2012 13:53:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, mfleming@intel.com, bhelgaas@google.com
Subject: Re: Use PCI ROMs from EFI boot services
Message-ID: <20120824125301.GA11988@srcf.ucam.org>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <1345800601.21476.140.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345800601.21476.140.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 10:30:01AM +0100, David Woodhouse wrote:
> On Thu, 2012-08-23 at 12:36 -0400, Matthew Garrett wrote:
> > V3 just fixes all the casting issues and incorporates David's change in
> > search ordering.
> 
> I appreciate there are other issues with kexec under EFI, but let's not
> make it worse. What is the plan for making this work *after* kexec? Do
> these blobs get passed from the old kernel to the new? Does that work
> already?

kexec would presumably need to reconstruct the setup_data from the PCI 
objects.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
