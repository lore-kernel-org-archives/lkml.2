Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab1FIUbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:31:32 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54082 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755887Ab1FIUbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:31:31 -0400
X-Sasl-enc: 776vPc+ZidDB7LLgm4M34Plhm3mE98/zns7D/sAikott 1307651490
Date: Thu, 9 Jun 2011 13:31:17 -0700
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        alan@lxorguk.ukuu.org.uk, kumar.gala@freescale.com,
        benh@kernel.crashing.org, akpm@kernel.org, cmetcalf@tilera.com,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisor
 management driver
Message-ID: <20110609203117.GB14235@kroah.com>
References: <1307646794-26374-1-git-send-email-timur@freescale.com>
 <201106092213.13755.arnd@arndb.de>
 <4DF12A94.6070605@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF12A94.6070605@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 03:18:28PM -0500, Timur Tabi wrote:
> > More importantly, the code you have chose (0) conflicts with existing drivers
> > (frame buffer, scsi and wavefront among others). Please chose a free one and
> > add it to Documentation/ioctl/ioctl-number.txt in the same patch.
> 
> Ok, I was really hoping to avoid doing this.  Like I said, binary compatibility
> is important, and changing the type will break my existing apps.  Are you
> insisting that I pick a new number?

Why is binary compatibility important?  Isn't this a brand new driver
for a brand new system?  What userspace tools are out there in the wild
for such a thing?

confused,

greg k-h
