Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1GFPTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:19:14 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:55029 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572Ab1GFPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:19:12 -0400
X-Sasl-enc: pfuuqZnn0MfQnKQCEnCiYv66SzloAe4cFhV1xe+nU8ge 1309965552
Date: Wed, 6 Jul 2011 08:12:17 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20110706151217.GB7465@kroah.com>
References: <20110706150916.13ff2bc5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706150916.13ff2bc5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 03:09:16PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> make[4]: *** No rule to make target `drivers/staging/gma500/cdv_intel_crt.o', needed by `drivers/staging/gma500/psb_gfx.o'.  Stop.
> drivers/staging/gma500/cdv_device.c:28:24: fatal error: cdv_device.h: No such file or directory
> 
> I see that these have already been reported elsewhere - it would have
> been nice if these patches had not been added to the staging tree
> destined for linux-next until *after* they were build tested (and
> fixed). :-(

I had to push out so that Alan could sync up and fix the error.  You
pulled inbetween his responding to me and hit the problem window.  My
tree is now building correctly and this will not happen tomorrow.

Sorry for the inconvenience,

greg k-h
