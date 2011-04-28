Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab1D1DKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:10:34 -0400
Received: from kroah.org ([198.145.64.141]:60136 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab1D1DKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:10:33 -0400
Date: Wed, 27 Apr 2011 20:06:01 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20110428030601.GA32204@kroah.com>
References: <20110428125913.9699516d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428125913.9699516d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:59:13PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/rt2860/common/cmm_data_pci.c
> drivers/staging/rt2860/common/cmm_data_usb.c between commit e9c549998dc2
> ("Revert wrong fixes for common misspellings") from Linus' tree and
> commit fefecc6989b4 ("staging: rt2860sta and rt2870sta: Remove drivers
> replaced in net/wireless") from the staging tree.
> 
> The files modified by the former were removed by the latter, so I did
> that.

Thanks, that is correct.

greg k-h
