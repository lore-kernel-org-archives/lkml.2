Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2K2FS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:18:56 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52439 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179Ab2K2FSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:18:54 -0500
X-Sasl-enc: xyBspCq5fpdfg/siGHzU2uZmjip59p9zogrB1Y6sawgU 1354166333
Date: Wed, 28 Nov 2012 21:20:31 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the driver-core tree with the mfd
 tree
Message-ID: <20121129052031.GO4375@kroah.com>
References: <20121129150044.3795f21cd3913abc0c10f45c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129150044.3795f21cd3913abc0c10f45c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:00:44PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/mfd/tps65090.c between various commits from the mfd tree and
> commits 84449216b01f ("mfd: remove use of __devexit_p"), f791be492f76
> ("mfd: remove use of __devinit") and 4740f73fe538 ("mfd: remove use of
> __devexit") from the driver-core tree.
> 
> I fixed it up (by using the mfd tree version) and can carry the fix as
> necessary (no action is required).

Looks good, thanks.

greg k-h
