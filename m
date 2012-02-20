Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab2BTFjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 00:39:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:13619 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab2BTFjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 00:39:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="112222133"
Message-ID: <1329716353.1511.19.camel@rui.sh.intel.com>
Subject: Re: [RFC PATCH 1/6] ACPI: Introduce ACPI D3_COLD state support
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Date: Mon, 20 Feb 2012 13:39:13 +0800
In-Reply-To: <201202172323.18022.rjw@sisk.pl>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
	 <201202142329.16516.rjw@sisk.pl>
	 <1329376106.28581.5.camel@rui.sh.intel.com>
	 <201202172323.18022.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 五, 2012-02-17 at 23:23 +0100, Rafael J. Wysocki wrote:
> > Okay, agreed.
> > so how about this? _PR3 equals D3_HOT support.
> 
> Yes, I can agree with that. :-)
> 
> > > > Hmm, how about set D3_COLD support if _PR3 exists, but leave a warning
> > > > message if _OFF doesn't exist, for now?
> > > 
> > > I don't think we need to set D3_COLD support at all.  In fact, it is always
> > > supported (as I said, if all power resources used by a device are off, the
> > > device is in D3_COLD pretty much by definition).
> > > 
> > Yeah, but it seems that Linux uses ACPI_D3 for both ACPICA D3_HOT and D3
> > (off). I'm generating a patch to remove ACPI_D3_COLD and introduce
> > D3_HOT support in Linux kernel.
> 
> That's a good idea in my opinion.

Great.
Patch will be sent out later.

thanks,
rui

