Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2BTKi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:38:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:57544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab2BTKiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:38:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="110037416"
Date: Mon, 20 Feb 2012 11:46:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH V4 1/2] MFD: TPS65217: Add new mfd device for TPS65217
Message-ID: <20120220104604.GO5387@sortiz-mobl>
References: <1326278501-29798-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326278501-29798-1-git-send-email-anilkumar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anilkumar,

On Wed, Jan 11, 2012 at 04:11:41PM +0530, AnilKumar Ch wrote:
> The TPS65217 chip is a power management IC for Portable Navigation Systems
> and Tablet Computing devices. It contains the following components:
> 
> - Regulators
> - White LED
> - USB battery charger
> 
> This patch adds support for tps65217 mfd device. At this time only
> the regulator functionality is made available.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
