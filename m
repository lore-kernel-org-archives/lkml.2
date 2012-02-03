Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab2BCPJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:09:18 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54666 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756015Ab2BCPJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:09:15 -0500
X-Sasl-enc: WpOWJsX7cs/9sirXEWwPrXSqT6/uX4MsmYRUKClM8E9r 1328281753
Date: Fri, 3 Feb 2012 07:07:15 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
Message-ID: <20120203150715.GA19534@kroah.com>
References: <20120203145106.3c166564b7081d94ee2e79cd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203145106.3c166564b7081d94ee2e79cd@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 02:51:06PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/base/cpu.c between commit 2885e25c422f ("driver core: cpu: remove
> kernel warning when removing a cpu") from the driver-core.current tree
> and commit fad12ac8c8c2 ("CPU: Introduce ARCH_HAS_CPU_AUTOPROBE and X86
> parts") from the driver-core tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks for this, I'll fix it up when I merge them back together when
3.3-rc3 comes out.

greg k-h
