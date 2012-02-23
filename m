Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab2BWQjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:39:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:62127 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab2BWQjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:39:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109974396"
Date: Thu, 23 Feb 2012 17:39:01 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] mfd: tps65912: Initialize irq platform data properly
Message-ID: <20120223163901.GN24377@sortiz-mobl>
References: <1329637811.11495.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329637811.11495.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Sun, Feb 19, 2012 at 03:50:11PM +0800, Axel Lin wrote:
> irq_base of the tps65912 irq platform data should be
> initialized with the board provided irq_base data.
Thanks, patch applied to my for-next and for-linus branches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
