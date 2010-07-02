Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0GBFrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 01:47:21 -0400
Received: from kroah.org ([198.145.64.141]:34950 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab0GBFrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 01:47:20 -0400
Date: Thu, 1 Jul 2010 22:46:48 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Glendinning <steve.glendinning@smsc.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 jdelvare-hwmon tree
Message-ID: <20100702054648.GA18023@kroah.com>
References: <20100702153827.cecff5e6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702153827.cecff5e6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 03:38:27PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> MAINTAINERS drivers/hwmon/emc2103.c between commit
> 7c73bc52c98623e7ae2831ec8df80e882aa4087f ("hwmon: Add driver for SMSC
> EMC2103 temperature monitor and fan controller") from the jdelvare-hwmon
> tree and commit 3b52586d66843792f6556b3dd33205375d9b4196 ("hwmon: Add
> driver for SMSC EMC2103 temperature monitor and fan controller") from the
> driver-core tree.
> 
> Looks like two versions of the same patch.  I used the newer one (from
> the jdelvare-hwmon tree).  I guess this should be dropped from one of the
> two trees.

Yes, it will be dropped from my tree tomorrow, sorry, I was busy with
the -stable stuff for the past few days.

thanks,

greg k-h
