Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1FIUvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:51:42 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47893 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049Ab1FIUvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:51:33 -0400
X-Sasl-enc: cqHjShANOwbsXcobgXHqvI9zRfrjEOZUibJCadzT+jNx 1307652692
Date: Thu, 9 Jun 2011 13:51:11 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan Mels <arjan.mels@gmx.net>, matt mooney <mfm@muteddisk.com>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20110609205111.GB32526@kroah.com>
References: <20110609165804.2e96bb77.sfr@canb.auug.org.au>
 <20110609184206.GC2760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609184206.GC2760@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 11:42:06AM -0700, Greg KH wrote:
> On Thu, Jun 09, 2011 at 04:58:04PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/staging/usbip/stub_dev.c between commit d3ac07788017 ("staging:
> > usbip: bugfix prevent driver unbind") from the staging.current tree and
> > commit d012c2a5aca1 ("staging: usbip: stub_dev.c: move stub_driver
> > definition and update driver name") from the staging tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.
> 
> Looks correct, thanks for doing this.

This should now be resolved.

greg k-h
