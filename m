Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2CAKoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:44:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:46220 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab2CAKoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:44:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131574616"
Date: Thu, 1 Mar 2012 11:51:44 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@openmoko.org>,
        Harald Welte <laforge@openmoko.org>
Subject: Re: [PATCH 2/2] mfd: include linux/mfd/pcf50633/mbc.h in
 pcf50633-irq.c
Message-ID: <20120301105144.GE9008@sortiz-mobl>
References: <1330141014.10677.0.camel@phoenix>
 <1330141073.10677.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330141073.10677.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Sat, Feb 25, 2012 at 11:37:53AM +0800, Axel Lin wrote:
> Include linux/mfd/pcf50633/mbc.h instead of duplicating the same defines.
Thanks, patch applied as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
