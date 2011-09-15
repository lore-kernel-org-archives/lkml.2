Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893Ab1IOOpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:45:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab1IOOpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:45:12 -0400
Date: Thu, 15 Sep 2011 16:40:15 +0200
From: Greg KH <gregkh@suse.de>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing
Message-ID: <20110915144015.GC20602@suse.de>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 02:36:53PM -0400, Neil Horman wrote:
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-devices-msi_irqs
> @@ -0,0 +1,17 @@
> +What:		/sys/devices/.../power/

I don't think this is the file that you are describing here :)

And I see you have not tried to remove a PCI device with this patch
running, right?

Please do so and properly fix up the messages that the kernel spits at
you.

thanks,

greg k-h
