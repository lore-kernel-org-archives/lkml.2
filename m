Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013Ab1IOPII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:08:08 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48001 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899Ab1IOPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:08:06 -0400
Date: Thu, 15 Sep 2011 11:07:56 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing
Message-ID: <20110915150756.GB14665@hmsreliant.think-freely.org>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <20110915144015.GC20602@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915144015.GC20602@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 04:40:15PM +0200, Greg KH wrote:
> On Wed, Sep 14, 2011 at 02:36:53PM -0400, Neil Horman wrote:
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-devices-msi_irqs
> > @@ -0,0 +1,17 @@
> > +What:		/sys/devices/.../power/
> 
> I don't think this is the file that you are describing here :)
> 
Yeah, you're right, thats what I get for copying an existing entry and assuming
there was only one devices subdir :)

> And I see you have not tried to remove a PCI device with this patch
> running, right?
> 
> Please do so and properly fix up the messages that the kernel spits at
> you.
> 
Hadn't considered doing that, no, I'll give it a shot and repost fixes.

Thanks
Neil

