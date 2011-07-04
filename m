Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab1GDPTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:19:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:28085 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883Ab1GDPTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:19:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,472,1304319600"; 
   d="scan'208";a="21400513"
Date: Mon, 4 Jul 2011 17:19:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, cbouatmailru@gmail.com,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH 2/2] regulator: Add a new regulator for charge control of
 MAX8998/LP3974
Message-ID: <20110704151942.GI3021@sortiz-mobl>
References: <1308909859-3674-1-git-send-email-dg77.kim@samsung.com>
 <1308909859-3674-3-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308909859-3674-3-git-send-email-dg77.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 24, 2011 at 07:04:19PM +0900, Donggeun Kim wrote:
> With the new regulator, "CHARGER", users can control charging current and
> turn on and off the charger.
> Note that the charger specification of LP3974 is different from
> that of MAX8998.
> 
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
For the MFD part:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
