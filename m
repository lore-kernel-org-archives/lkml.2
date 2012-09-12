Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298Ab2ILQNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:13:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53232 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759809Ab2ILQNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:13:53 -0400
X-Sasl-enc: jhyqhVsV/Tm/tGCUHLp/zYH8kJ3qoolPyJ+hfiGpZGRJ 1347466432
Date: Wed, 12 Sep 2012 09:13:51 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: linux-next: manual merge of the staging tree with the thermal
 tree
Message-ID: <20120912161351.GD7273@kroah.com>
References: <20120912155231.716530c364bb20bd43efec0d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912155231.716530c364bb20bd43efec0d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 03:52:31PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/omap-thermal/omap-thermal-common.c between commit
> 76f726fb24bd ("Thermal: Remove tc1/tc2 in generic thermal layer") from
> the thermal tree and commit 765a1939a364 ("staging: omap-thermal: fix
> polling period settings") from the staging tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
> 


Looks good to me, thanks.

greg k-h
