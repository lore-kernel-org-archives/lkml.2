Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab0JFTcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:32:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35104 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0JFTcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:32:41 -0400
Date: Wed, 6 Oct 2010 20:32:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Moore, Robert" <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
	time as methods
Message-ID: <20101006193228.GA3030@srcf.ucam.org>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com> <4911F71203A09E4D9981D27F9D830858B4893B89@orsmsx503.amr.corp.intel.com> <20101006161854.GA30584@srcf.ucam.org> <201010062130.27564.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010062130.27564.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 09:30:27PM +0200, Rafael J. Wysocki wrote:

> So, as I said, we can modify acpi_gpe_can_wake() to pass a device object to
> ACPICA.  Then, the device object will be added to the list of devices to Notify()
> if the GPE is signaled.  Plain and simple.

Yeah, that does seem to be the simplest solution.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
