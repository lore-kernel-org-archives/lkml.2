Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab1DMTT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:19:58 -0400
Received: from kroah.org ([198.145.64.141]:51325 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab1DMTT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:19:57 -0400
Date: Wed, 13 Apr 2011 12:18:42 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Roland Vossen <rvossen@broadcom.com>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20110413191842.GA13359@kroah.com>
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

Ok, all of the staging-next tree merge issues with Linus's tree should
now be resolved.  Please let me know if there are any that I missed.

thanks,

greg k-h
