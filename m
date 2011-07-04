Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab1GDPXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:23:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:63911 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab1GDPXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:23:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,473,1304319600"; 
   d="scan'208";a="23259592"
Date: Mon, 4 Jul 2011 17:23:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] mfd: Fix off-by-one value range checking for
 tps65912_i2c_write
Message-ID: <20110704152346.GK3021@sortiz-mobl>
References: <1308926277.2628.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308926277.2628.6.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Fri, Jun 24, 2011 at 10:37:57PM +0800, Axel Lin wrote:
> From c5124060f13296bfc8cbbbb8298cf4b9b1faa1e9 Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Fri, 24 Jun 2011 15:34:16 +0800
> Subject: [PATCH] mfd: Fix off-by-one value range checking for tps65912_i2c_write
> 
> If bytes == (TPS6591X_MAX_REGISTER + 1), we have a buffer overflow when
> doing memcpy(&msg[1], src, bytes).
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
