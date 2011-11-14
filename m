Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1KNAWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:22:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:50708 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1KNAWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:22:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,504,1315206000"; 
   d="scan'208";a="84715928"
Date: Mon, 14 Nov 2011 01:26:25 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ilya Yanok <yanok@emcraft.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] twl-core: fix oops while calling twl_i2c_* for unbound
 driver
Message-ID: <20111114002625.GJ22218@sortiz-mobl>
References: <1312232428-31001-1-git-send-email-yanok@emcraft.com>
 <4EB9C824.5070504@emcraft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB9C824.5070504@emcraft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilya,

On Wed, Nov 09, 2011 at 04:24:04AM +0400, Ilya Yanok wrote:
> Hi,
> 
> this is still unfixed. twl_i2c_{read,write} are exported and can be
> called before driver initialization so we have to check it before
> dereferencing twl_map.
> 
> Regards, Ilya.
Thanks for the fix. This one should make it to 3.2 as I applied it to my
for-linux branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
