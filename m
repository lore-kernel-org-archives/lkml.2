Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab0FASre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:47:34 -0400
Received: from kroah.org ([198.145.64.141]:46924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230Ab0FASrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:47:33 -0400
Date: Tue, 1 Jun 2010 11:39:20 -0700
From: Greg KH <greg@kroah.com>
To: Frank Pan <frankpzh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       Mitch Williams <mitch.a.williams@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add a helper function in PCI IOV to get VF device
Message-ID: <20100601183920.GB19955@kroah.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 01:05:25PM +0800, Frank Pan wrote:
> Greetings,
> 
> The motivation is make VF device visible to PF driver. PF driver
> may need this to access VF's PCI configuration.

What is "VF" and "PF" here?

> Another use case is in sysfs symbolic linking. Some of VF's sysfs
> entries are created by PF driver. For example, /sys/class/net/ethx/vfx
> in Intel 82576 NIC driver. Makeing a symbolic link from VF's pci device
> to this path also must be done in PF's driver.

No, the network core should create that symlink, not the driver, right?

thanks,

greg k-h
