Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab1DHVpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:45:10 -0400
Received: from kroah.org ([198.145.64.141]:46520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405Ab1DHVpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:45:08 -0400
Date: Fri, 8 Apr 2011 13:55:01 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Roland Vossen <rvossen@broadcom.com>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20110408205501.GB23417@kroah.com>
References: <20110408154756.538a59f2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408154756.538a59f2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 03:47:56PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/brcm80211/README between commit 25985edcedea ("Fix common
> misspellings") from Linus' tree and commit 4a266c4fc99d ("staging:
> brcm80211: moved several README items to website") from the staging tree.
> 
> The latter removed the text that the former fixed up, so I did that.

Thanks, it looks like the spelling changes hit a lot of staging stuff so
I will merge with Linus's tree and resolve them next week.

thanks,

greg k-h
