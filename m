Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2HAQyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:54:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51015 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2HAQyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:54:07 -0400
Date: Wed, 1 Aug 2012 17:54:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH V2 1/4] EFI: Stash ROMs if they're not in the PCI BAR
Message-ID: <20120801165400.GA3042@srcf.ucam.org>
References: <1343407934-459-1-git-send-email-mjg@redhat.com>
 <20120731223240.GD19134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731223240.GD19134@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 03:32:40PM -0700, Greg KH wrote:

> With this series, does the latest MacBook work properly for the Intel
> graphics driver?  Or is this to resolve some other hardware issue?

Apple only seem to provide the ROM for the radeon. Intel normally 
stands a much better chance of working without a ROM - the only thing it 
really uses it for is the VBT, and I'm thinking about a couple of ways 
of handlng that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
