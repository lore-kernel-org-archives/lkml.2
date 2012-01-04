Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab2ADXKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:10:41 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38990 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757313Ab2ADXJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:09:25 -0500
X-Sasl-enc: 4wg2Ak/clFADOHMmBjoEzYFudG3if6AZoA+mQTwn6e48 1325718564
Date: Wed, 4 Jan 2012 15:08:23 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the driver-core tree with the arm
 tree
Message-ID: <20120104230823.GG24583@kroah.com>
References: <20111228164052.7357f637a6bece1ef8068da6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228164052.7357f637a6bece1ef8068da6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 04:40:52PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/arm/plat-samsung/include/plat/cpu.h between commit b024043b6d0d
> ("ARM: 7245/1: S3C64XX: introduce arch/arm/mach-s3c64xx/common.[ch]")
> from the arm tree and commit 4a858cfc9af8 ("arm: convert sysdev_class to
> a regular subsystem") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good, thanks.

greg k-h
