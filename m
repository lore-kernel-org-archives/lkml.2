Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1EVTJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 15:09:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:17776 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab1EVTJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 15:09:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,252,1304319600"; 
   d="scan'208";a="2647038"
Date: Sun, 22 May 2011 21:09:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Keshava Munegowda <keshava_mgowda@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] mfd: Fix omap_usbhs_alloc_children error handling
Message-ID: <20110522190939.GB18610@sortiz-mobl>
References: <1305353736.11286.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305353736.11286.2.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Sat, May 14, 2011 at 02:15:36PM +0800, Axel Lin wrote:
> 1. Return proper error if omap_usbhs_alloc_child fails
> 2. In the case of goto err_ehci, we should call platform_device_unregister(ehci)
>    instead of platform_device_put(ehci) because we have already added the
>    platform device to device hierarchy.
Patch applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
