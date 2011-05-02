Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab1EBJVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:21:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:26825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab1EBJVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:21:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,301,1301900400"; 
   d="scan'208";a="686911182"
Date: Mon, 2 May 2011 11:21:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] mfd: fix tps6586x GPIO value setting
Message-ID: <20110502092151.GA740@sortiz-mobl>
References: <1302620158-6298-1-git-send-email-vpalatin@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302620158-6298-1-git-send-email-vpalatin@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On Tue, Apr 12, 2011 at 10:55:58AM -0400, Vincent Palatin wrote:
> In the current code, every time we set a TPS6586x GPIO pin,
> the tps6586x_gpio_set function is resetting all other GPIO pins.
> We need to update the right GPIOxOUT bit of the GPIOSET2 register instead
> of overriding the full value.
> 
> Tested by setting sequentially GPIO2 and GPIO3 and verifying the
> pins voltage.
Patch applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
