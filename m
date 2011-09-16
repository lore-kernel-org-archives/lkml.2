Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1IPIuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:50:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1IPIuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:50:18 -0400
Date: Fri, 16 Sep 2011 10:36:46 +0200
From: Greg KH <gregkh@suse.de>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v2)
Message-ID: <20110916083646.GA30915@suse.de>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1316117318-22027-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316117318-22027-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 04:08:38PM -0400, Neil Horman wrote:
> +static struct kobj_type msi_irq_ktype = {
> +	.sysfs_ops = &msi_irq_sysfs_ops,
> +	.default_attrs = msi_irq_default_attrs,
> +};

You still haven't successfully removed the kobject associated with this
kobj_type.  Otherwise you would have seen the error messages in the
kernel log and fixed up what it told you to fix.

Please do so.

greg k-h
