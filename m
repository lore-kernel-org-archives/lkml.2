Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab2K2FTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:19:24 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46051 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201Ab2K2FTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:19:21 -0500
X-Sasl-enc: G0vy0Mad1RDdCIX2aJmdGA7B9x2mpSwa0BG2APxqUGUA 1354166360
Date: Wed, 28 Nov 2012 21:20:58 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the mfd
 tree
Message-ID: <20121129052058.GR4375@kroah.com>
References: <20121129144712.d6fcfdc94dbdd6f2d4bc7e79@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129144712.d6fcfdc94dbdd6f2d4bc7e79@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:47:12PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/mfd/ab8500-core.c between commit 8ae754ebd5ed ("mfd: ab8500-core:
> Remove unused ab8500-gpio IRQ ranges") from the mfd tree and commit
> a9e9ce4c4167 ("mfd: remove use of __devinitdata") from the driver-core
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
