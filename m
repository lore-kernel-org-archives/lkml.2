Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab2BBT1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:27:21 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37377 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429Ab2BBT1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:27:19 -0500
X-Sasl-enc: LG9LRf4Mk4t2R1+v9AR5yHuEO+++LLQZrKoejQ72nOEa 1328210838
Date: Thu, 2 Feb 2012 11:26:39 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>
Subject: Re: linux-next: manual merge of the driver-core tree with Linus' tree
Message-ID: <20120202192639.GA5798@kroah.com>
References: <20120130132451.1049903dbf990fed5876e5bc@canb.auug.org.au>
 <20120130023517.GA7937@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130023517.GA7937@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 06:35:17PM -0800, Greg KH wrote:
> On Mon, Jan 30, 2012 at 01:24:51PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the driver-core tree got a conflict in
> > drivers/acpi/processor_driver.c between commit 54d5dcc45af7 ("ACPI
> > processor hotplug: Split up acpi_processor_add") from Linus' tree and
> > commit 9061e0e16700 ("ACPI: Load acpi-cpufreq from processor driver
> > automatically") from the driver-core tree.
> > 
> > I fixed it up (I think- see below) and can carry the fix as necessary.
> 
> Thanks, I'll merge the driver-core next tree when 3.3-rc2 is out to
> resolve this problem.

This should now be resolved.

thanks,

greg k-h
