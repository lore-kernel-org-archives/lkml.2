Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1LSLyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:54:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:16671 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab1LSLyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:54:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103763591"
Date: Mon, 19 Dec 2011 12:58:32 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH] mfd: Avoid writing uninitialized value to device
Message-ID: <20111219115832.GL11800@sortiz-mobl>
References: <1323333920.10774.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323333920.10774.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, Dec 08, 2011 at 04:45:20PM +0800, Axel Lin wrote:
> Avoid writing uninitialized value to device by explicitly initialize
> zero to 0.

88pm860x is now using the regmap API, so this patch is no longer relevant.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
