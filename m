Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0ECVC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:02:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:33920 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab0ECVC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,321,1270450800"; 
   d="scan'208";a="514704434"
Date: Mon, 3 May 2010 14:02:25 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "stable@kernel.org" <stable@kernel.org>, davem@davemloft.net
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "brandon@ifup.org" <brandon@ifup.org>
Subject: Re: [stable] ixgbe: Fix return of invalid txq
In-Reply-To: <alpine.WNT.2.00.1005031333200.4376@jbrandeb-desk1.amr.corp.intel.com>
Message-ID: <alpine.WNT.2.00.1005031401100.4376@jbrandeb-desk1.amr.corp.intel.com>
References: <alpine.WNT.2.00.1005031333200.4376@jbrandeb-desk1.amr.corp.intel.com>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

putting davem on to: line...  sorry for not including on first email.

On Mon, 3 May 2010, Brandeburg, Jesse wrote:

> Please consider commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f for 
> inclusion in 2.6.32.y (it is already in 2.6.33.y)
> 
> Here is the commit message, it fixes a panic on machines with a larger 
> number of cpus than ixgbe has tx queues (64).
> 
> commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f
> Author: Krishna Kumar <krkumar2@in.ibm.com>
> Date:   Wed Feb 3 13:13:10 2010 +0000
> 
>     ixgbe: Fix return of invalid txq
> 
>     a developer had complained of getting lots of warnings:
> 
>     "eth16 selects TX queue 98, but real number of TX queues is 64"
>     
> 	http://www.mail-archive.com/e1000-devel@lists.sourceforge.net/msg02200.html
> 
>     As there was no follow up on that bug, I am submitting this
>     patch assuming that the other return points will not return
>     invalid txq's, and also that this fixes the bug (not tested).
> 
>     Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
>     Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>     Acked-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
>     Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> 
