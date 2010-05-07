Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab0EGWjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:39:44 -0400
Received: from kroah.org ([198.145.64.141]:60539 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab0EGWjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:39:42 -0400
Date: Fri, 7 May 2010 15:25:59 -0700
From: Greg KH <greg@kroah.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: stable@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       brandon@ifup.org, David Miller <davem@davemloft.net>
Subject: Re: [stable]  ixgbe: Fix return of invalid txq
Message-ID: <20100507222559.GE26579@kroah.com>
References: <alpine.WNT.2.00.1005031333200.4376@jbrandeb-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.WNT.2.00.1005031333200.4376@jbrandeb-desk1.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 01:56:57PM -0700, Brandeburg, Jesse wrote:
> Please consider commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f for 
> inclusion in 2.6.32.y (it is already in 2.6.33.y)
> 
> Here is the commit message, it fixes a panic on machines with a larger 
> number of cpus than ixgbe has tx queues (64).
> 
> commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f

This doesn't apply at all on the .32-stable tree, as the logic has
changed there.  Care to properly backport it if you really need it
there?

thanks,

greg k-h
