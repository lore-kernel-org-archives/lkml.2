Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1EDSeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:34:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab1EDSeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:34:23 -0400
Date: Wed, 4 May 2011 11:34:01 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 4 (hyperv / vmbus)
Message-ID: <20110504183401.GB9012@suse.de>
References: <20110504144759.802483cc.sfr@canb.auug.org.au>
 <20110504094908.b8295d22.randy.dunlap@oracle.com>
 <6E21E5352C11B742B20C142EB499E0481DFD54@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DFD54@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 04:56:02PM +0000, KY Srinivasan wrote:
> > vmbus_drv.c sure looks like it requires (depends on) both ACPI and PCI.
> > That should be expressed somewhere in its Kconfig file.
> 
> Greg,
> 
> Do you want me to send you a patch to fix this?

Yes please.
