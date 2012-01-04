Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2ADXJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:09:31 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48155 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757177Ab2ADXJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:09:24 -0500
X-Sasl-enc: uZRanKjbUjnOob+LO5206WKWLTvZuaZb0vv20dfe6yq+ 1325718562
Date: Wed, 4 Jan 2012 15:08:09 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arun R Bharadwaj <arun.r.bharadwaj@gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 powerpc tree
Message-ID: <20120104230809.GF24583@kroah.com>
References: <20111228165102.fbb6433fd94d11240134327e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228165102.fbb6433fd94d11240134327e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 04:51:02PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/powerpc/kernel/sysfs.c between commit 595fe91447b0 ("powerpc: Export
> PIR data through sysfs") from the powerpc tree and commits 8a25a2fd126c
> ("cpu: convert 'cpu' and 'machinecheck' sysdev_class to a regular
> subsystem") and 707827f3387d ("powerpc/cpuidle: cpuidle driver for
> pSeries") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good, thanks.

greg k-h
