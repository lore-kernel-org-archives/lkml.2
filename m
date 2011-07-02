Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1GBKIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 06:08:25 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:53664 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab1GBKIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 06:08:23 -0400
Date: Sat, 2 Jul 2011 14:07:12 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-uvc-devel@lists.berlios.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] USB: EHCI: Allow users to override 80% max
	periodic bandwidth
Message-ID: <20110702100712.GA18338@tugrik.mns.mnsspb.ru>
References: <cover.1309520144.git.kirr@mns.spb.ru> <69ea2dd940481508f190419c53c780b626460b22.1309520144.git.kirr@mns.spb.ru> <20110701212427.GA11831@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701212427.GA11831@kroah.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 02:24:27PM -0700, Greg KH wrote:
> On Fri, Jul 01, 2011 at 03:47:11PM +0400, Kirill Smelkov wrote:
> >  drivers/usb/host/ehci-sysfs.c |  104 +++++++++++++++++++++++++++++++++++++++--
> 
> As you are adding new sysfs files, it is required that you also add new
> entries in the Documentation/ABI/ directory.
> 
> Please do that for these files so that people have an idea of what they
> are, and how to use them.
> 
> Care to redo this series with that change?

Sure, I'll post v4 with documentation included.

Thanks,
Kirill
