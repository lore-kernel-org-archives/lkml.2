Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161062Ab2KNJt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:49:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:24249 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161051Ab2KNJtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:49:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,249,1352102400"; 
   d="scan'208";a="168193394"
Date: Wed, 14 Nov 2012 11:52:32 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, mathias.nyman@linux.intel.com,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/3 rev 2] Centralized parsing of ACPI device resources
Message-ID: <20121114095232.GN31759@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <2429141.J1r7BIpiiT@vostro.rjw.lan>
 <5953163.ZajFIHZXph@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5953163.ZajFIHZXph@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 09:51:39PM +0100, Rafael J. Wysocki wrote:
> Updated series, taking the Mika's feedback into account, follows.  There are
> bug fixes in [1/3], [2/3] is unchanged and the new [3/3] is a replacement, done
> in a different way because of some ACPICA limitations I didn't realize before.

I've now tested this series on my ACPI 5 enabled test machine and
everything works fine - I can see the platform devices and that they have
the ACPI handle attached.

For the whole series,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

(testing has been limited on one ACPI 5 machine, though).

I guess I can start preparing the GPIO/SPI/I2C patches soon ;-)
