Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab0INEOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:14:50 -0400
Received: from kroah.org ([198.145.64.141]:58526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab0INEO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:14:28 -0400
Date: Mon, 13 Sep 2010 21:09:15 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the mfd
	tree
Message-ID: <20100914040915.GD11972@kroah.com>
References: <20100914122510.99c3e3b3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914122510.99c3e3b3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 12:25:10PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/misc/Makefile between commit
> 03f582a93ecca6e9584b622570022abf08ed03ec ("misc: Add ab8500 pwm driver")
> from the mfd tree and commit b6de6c8f5a6fc18c5c67bb4e53f3d0cfd266b07b
> ("add Packet hub driver for Topcliff Platform controller hub") from the
> driver-core tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

Fix looks fine to me, thanks.

greg k-h
