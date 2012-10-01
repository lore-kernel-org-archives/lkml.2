Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2JAGfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 02:35:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:29138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab2JAGfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 02:35:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,514,1344236400"; 
   d="scan'208";a="217290687"
Date: Mon, 1 Oct 2012 09:37:53 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC PATCH 1/6] Introduce acpi_match_device_id().
Message-ID: <20121001063753.GE15548@intel.com>
References: <1348817910.10877.321.camel@rui.sh.intel.com>
 <20120928141347.GC15548@intel.com>
 <744357E9AAD1214791ACBA4B0B90926322C156@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926322C156@SHSMSX101.ccr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 01:31:52PM +0000, Zhang, Rui wrote:
>  
> > > +{
> > > +	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
> > 
> > If the device is not bound to an ACPI handle this will return NULL. And
> > I don't see you doing that in this series meaning that..
> > 
> 
> 
> You're right, I should set pdev->archdata.acpi_handle to the I2C
> controller in i2c_root.c.

There already is an API for that - check drivers/acpi/glue.c.
