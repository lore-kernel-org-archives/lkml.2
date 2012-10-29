Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab2J2LMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:12:17 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43663 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab2J2LMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:12:16 -0400
Date: Mon, 29 Oct 2012 12:12:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
        len.brown@intel.com, rjw@sisk.pl, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 1/2] ACPI, x86: export acpi_[un]register_gsi()
Message-ID: <20121029111210.GB22569@gmail.com>
References: <1351502792-13221-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351502792-13221-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mika Westerberg <mika.westerberg@linux.intel.com> wrote:

> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> These functions might be called from modules as well so make sure they are
> exported. In addition we implement empty version of acpi_unregister_gsi() and
> remove the one from pci_irq.c.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> Although there are no modules that use this currently, we are working on
> ACPI 5 device enumeration support that is going to use these functions and
> some of that code can be compiled as a module.

So why not submit these patches together with those patches?

Thanks,

	Ingo
