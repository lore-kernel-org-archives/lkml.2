Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab1LSPjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:39:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:39314 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1LSPjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:39:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="88110149"
Date: Mon, 19 Dec 2011 16:44:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Afzal Mohammed <afzal@ti.com>
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH v3] mfd: TPS65910: Make usable even if interrupt unused
Message-ID: <20111219154409.GO11800@sortiz-mobl>
References: <1323858935-25724-1-git-send-email-afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323858935-25724-1-git-send-email-afzal@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mohamed,

On Wed, Dec 14, 2011 at 04:05:35PM +0530, Afzal Mohammed wrote:
> TPS65910 can be used even if interrupt is unused.
> Hence let probe succeed in case interrupt can't be
> configured and let Kernel only to complain about it
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
