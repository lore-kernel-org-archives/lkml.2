Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757Ab1ITNEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:04:16 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51171 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab1ITNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:04:15 -0400
X-Sasl-enc: WW1UknHv67akx+j+BxlvLeRz7/GcwT/pYO+galsMKEWk 1316523854
Date: Tue, 20 Sep 2011 05:53:28 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20110920125328.GA9736@kroah.com>
References: <20110920164649.b22e95cf65f4678da99a0a81@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920164649.b22e95cf65f4678da99a0a81@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 04:46:49PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/comedi/drivers/ni_labpc.c between commit c19cc78efe92
> ("staging: fix comedi build when ISA_DMA_API is enabled but COMEDI_PCI is
> not enabled") from Linus' tree and commit d6aa8366dde1 ("staging: fix
> comedi build errors") from the staging tree.
> 
> I have used the version from Linus' tree.

Thank you, that should be correct.  I'll merge the two together when
kernel.org comes back.

greg k-h
