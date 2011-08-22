Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1HVOn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:43:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:62772 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab1HVOnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:43:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="40616011"
Date: Mon, 22 Aug 2011 16:45:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, Keshava Munegowda <keshava_mgowda@ti.com>
Subject: Re: [PATCH] mfd: omap-usb-host: Make TLL mode work again
Message-ID: <20110822144524.GV4607@sortiz-mobl>
References: <1313664271-694-1-git-send-email-gadiyar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313664271-694-1-git-send-email-gadiyar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anand,

On Thu, Aug 18, 2011 at 04:14:31PM +0530, Anand Gadiyar wrote:
> This code section seems to have been accidentally copy pasted.
> It causes incorrect bits to be set up in the TLL_CHANNEL_CONF
> register and prevents the TLL mode from working correctly.
Patch applied, with Felipe's ACK and stable@kernel.org Cc'ed.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
