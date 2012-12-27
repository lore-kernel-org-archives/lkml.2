Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2L0JaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:30:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:45302 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab2L0JaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:30:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,361,1355126400"; 
   d="scan'208";a="267402683"
Date: Thu, 27 Dec 2012 11:33:51 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 0/3] Thunderbolt workarounds
Message-ID: <20121227093351.GH20026@intel.com>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CAErSpo6QWZfZ9YQAXkDOPvqBrwhS4wEzrxiUSAi7myVfoDGaKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6QWZfZ9YQAXkDOPvqBrwhS4wEzrxiUSAi7myVfoDGaKA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 05:50:42PM -0700, Bjorn Helgaas wrote:
> On Thu, Dec 13, 2012 at 12:25 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > I had chance to test two PC setups with Thunderbolt: Acer Aspire S5 and
> > Intel DZ77RE-75K motherboard. Unfortunately, both of them are broken in
> > different ways.
> >
> > This patchset contains workarounds for the issues.
> >
> > Kirill A. Shutemov (3):
> >   PCI Hotplug: workaround for Thunderbolt on Acer Aspire S5
> >   PCI Hotplug: convert acpiphp_hp_work to use delayed work
> >   PCI Hotplug: workaround for Thunderbolt on Intel DZ77RE-75K
> >     motherboard
> >
> >  drivers/pci/hotplug/acpi_pcihp.c   |   13 +++++++++++++
> >  drivers/pci/hotplug/acpiphp_glue.c |   33 +++++++++++++++++++++++++--------
> >  2 files changed, 38 insertions(+), 8 deletions(-)
> 
> I'm ignoring these for now.  [1/3] has a hardcoded BIOS path that I
> don't think is the right approach and [3/3] has a timeout issue to be
> addressed.  [2/3] might be worthwhile by itself, but I'd rather merge
> a complete solution when it's ready.

OK. We'll rework the series with Kirill and submit a better solution.
