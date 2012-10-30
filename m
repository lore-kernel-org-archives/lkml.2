Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2J3Gy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 02:54:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:10538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2J3GyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 02:54:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,677,1344236400"; 
   d="scan'208";a="241807852"
Date: Tue, 30 Oct 2012 08:56:44 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
        len.brown@intel.com, rjw@sisk.pl, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 1/2] ACPI, x86: export acpi_[un]register_gsi()
Message-ID: <20121030065644.GH16648@intel.com>
References: <1351502792-13221-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121029111210.GB22569@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029111210.GB22569@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 12:12:10PM +0100, Ingo Molnar wrote:
> 
> * Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> 
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > 
> > These functions might be called from modules as well so make sure they are
> > exported. In addition we implement empty version of acpi_unregister_gsi() and
> > remove the one from pci_irq.c.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> > Although there are no modules that use this currently, we are working on
> > ACPI 5 device enumeration support that is going to use these functions and
> > some of that code can be compiled as a module.
> 
> So why not submit these patches together with those patches?

Ok, we will do that. At the same time we change them to use _GPL version of
the EXPORT_SYMBOL.

Thanks.
