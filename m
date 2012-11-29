Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab2K2FSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:18:18 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45184 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab2K2FSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:18:14 -0500
X-Sasl-enc: 5XhcQxyPG7i/5KoECJ8EM4naixdn6BHreE/5fTk5D+LM 1354166293
Date: Wed, 28 Nov 2012 21:19:51 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 battery tree
Message-ID: <20121129051951.GK4375@kroah.com>
References: <20121129151142.320443bcfadad110dcc88722@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129151142.320443bcfadad110dcc88722@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:11:42PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/power/ab8500_charger.c between commit 4aef72dbb2e8 ("ab8500: Add
> devicetree support for charger") from the battery tree and commit
> c8afa6406e60 ("power: remove use of __devinit") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
