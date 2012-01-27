Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2A0Wgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 17:36:49 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34983 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab2A0Wgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 17:36:47 -0500
X-Sasl-enc: EbCyDobcmRIawF+MM3vesWoMTg4ZnnpaF0rSuzDQAMWf 1327703806
Date: Fri, 27 Jan 2012 14:36:28 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Buesch <m@bues.ch>, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20120127223628.GA4358@kroah.com>
References: <20120127135912.e5f45bf1c4a99b114c18bf72@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127135912.e5f45bf1c4a99b114c18bf72@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 01:59:12PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/pci/xen-pcifront.c: In function 'pcifront_common_process':
> drivers/pci/xen-pcifront.c:596:6: error: used struct type value where scalar is required
> 
> Caused by commit f3ff9247088a ("Remove useless get_driver()/put_driver()
> calls").
> 
> Please build test this stuff ...

Sorry, I do build test this, but I didn't have Xen enabled in that
.config as I never run Xen :)

I'll queue up Alan's patch so all should be good now.

thanks,

greg k-h
