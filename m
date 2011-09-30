Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab1I3Mc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:32:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53318 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab1I3McY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:32:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 30 Sep 2011 14:32:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v4)
Message-ID: <20110930143211.5ab39c02@stein>
In-Reply-To: <1317307129-11579-1-git-send-email-nhorman@tuxdriver.com>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
	<1317307129-11579-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 29 Neil Horman wrote:
> (v4)
> Fixed up some spelling mistakes, and added a scissors line with a good
> commitlog, so that git-am drops all the version logging
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: linux-pci@vger.kernel.org

It drops these last 5 lines then too, doesn't it?

> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -66,6 +66,24 @@ Description:
>  		re-discover previously removed devices.
>  		Depends on CONFIG_HOTPLUG.
>  
> +What:		/sys/bus/pci/devices/.../msi_irqs/
> +Date:		September, 2011
> +Contact:	Neil Horman <nhorman@tuxdriver.com>
> +Description:
> +		The /sys/devices/.../msi_irqs directory contains a variable set
> +		sub-directories, with each sub-directory being named after a
> +		corresponding msi irq vector allocated to that device.

"contains a variable set _of_ sub-directories"?
-- 
Stefan Richter
-=====-==-== =--= ====-
http://arcgraph.de/sr/
