Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab2K2FR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:17:59 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39916 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836Ab2K2FR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:17:57 -0500
X-Sasl-enc: zomcvWDMYYYnouUfKe8q7sqD0O8Kh5DY1oPx9AJYeEFZ 1354166277
Date: Wed, 28 Nov 2012 21:19:35 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 battery tree
Message-ID: <20121129051935.GI4375@kroah.com>
References: <20121129151558.ecd7213462b330bc792870d7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129151558.ecd7213462b330bc792870d7@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:15:58PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/power/abx500_chargalg.c between commit a12810ab9fcf ("ab8500: Add
> devicetree support for chargalg") from the battery tree and commit
> c8afa6406e60 ("power: remove use of __devinit") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
