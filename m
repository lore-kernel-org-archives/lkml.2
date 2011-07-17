Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1GQJSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:18:24 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38793 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896Ab1GQJSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:18:18 -0400
X-Sasl-enc: 16j00vcx48fJeJgyCy+DodP9PyJKZEszL3f6+oT1MjMs 1310894297
Date: Sun, 17 Jul 2011 11:15:00 +0200
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20110717091500.GB25824@kroah.com>
References: <20110716231511.394534c7936a65d70a0a3ce6@canb.auug.org.au>
 <20110717003938.375976aa@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110717003938.375976aa@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 12:39:38AM +0100, Alan Cox wrote:
> On Sat, 16 Jul 2011 23:15:11 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Greg,
> > 
> > After merging the staging tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > drivers/video/Kconfig:36:error: recursive dependency detected!
> > drivers/video/Kconfig:36:	symbol FB is selected by
> > DRM_KMS_HELPER drivers/gpu/drm/Kconfig:22:	symbol
> > DRM_KMS_HELPER is selected by DRM_PSB
> > drivers/staging/gma500/Kconfig:1:	symbol DRM_PSB depends on
> > ACPI_VIDEO
> > 
> > Caused by commit 66dca5178c70 ("gma500: Fix dependencies").
> 
> Can you drop that one of your tree Greg - duplicated here and I need to
> think somewhat harder about how we sort that out.

Ok, now reverted.

thanks,

greg k-h
