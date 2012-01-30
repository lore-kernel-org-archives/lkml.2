Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2A3Cf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:35:26 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55895 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368Ab2A3CfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:35:25 -0500
X-Sasl-enc: u5LG8sNbAJUMwKTIncBt109wCQxrXkfGP7P7DQqtqKWc 1327890923
Date: Sun, 29 Jan 2012 18:35:17 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>
Subject: Re: linux-next: manual merge of the driver-core tree with Linus' tree
Message-ID: <20120130023517.GA7937@kroah.com>
References: <20120130132451.1049903dbf990fed5876e5bc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130132451.1049903dbf990fed5876e5bc@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 01:24:51PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/acpi/processor_driver.c between commit 54d5dcc45af7 ("ACPI
> processor hotplug: Split up acpi_processor_add") from Linus' tree and
> commit 9061e0e16700 ("ACPI: Load acpi-cpufreq from processor driver
> automatically") from the driver-core tree.
> 
> I fixed it up (I think- see below) and can carry the fix as necessary.

Thanks, I'll merge the driver-core next tree when 3.3-rc2 is out to
resolve this problem.

greg k-h
