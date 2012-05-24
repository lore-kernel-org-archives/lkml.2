Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170Ab2EXUpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:45:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43115 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab2EXUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:45:43 -0400
Date: Thu, 24 May 2012 21:45:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Wei Kong <wkong@novell.com>,
        Jean Delvare <jdelvare@suse.com>
Subject: Re: [PATCH] PCI / ACPI: Do not request control of ASPM if the BIOS
 has disabled it
Message-ID: <20120524204538.GA27819@srcf.ucam.org>
References: <201205242245.45888.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205242245.45888.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:45:45PM +0200, Rafael J. Wysocki wrote:

> However, knowing that the BIOS doesn't support ASPM, we shouldn't
> request the control of it, so we should remove
> (OSC_ACTIVE_STATE_PWR_SUPPORT | OSC_CLOCK_PWR_CAPABILITY_SUPPORT)
> from the flags before calling acpi_pci_osc_control_set() in those
> cases.  Failing to do so causes the evaluation of _OSC for the PCI
> root bridge to return error codes on some systems where it should
> work correctly.

Is there an example of an affected machine's DSDT?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
