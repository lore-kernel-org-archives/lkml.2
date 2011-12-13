Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1LMUoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:44:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:40235 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab1LMUoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:44:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101822266"
Date: Tue, 13 Dec 2011 21:49:15 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Afzal Mohammed <afzal@ti.com>, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, nsekhar@ti.com
Subject: Re: [PATCH v2-rebased] mfd: TPS65910: Make usable even if interrupt
 unused
Message-ID: <20111213204915.GF2796@sortiz-mobl>
References: <1323770273-21222-1-git-send-email-afzal@ti.com>
 <CAJ4dqQvJy5EHnkfp2Yf2bBg0LG7e3i9=3qL_S09Sn6oTxPc0XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ4dqQvJy5EHnkfp2Yf2bBg0LG7e3i9=3qL_S09Sn6oTxPc0XQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcus

On Tue, Dec 13, 2011 at 11:26:18AM +0100, Marcus Folkesson wrote:
> Is there any potential issue when calling free_irq on a non-requested irq?
> If it is, there should be a !irq check in tps65910_irq_exit or
> tps65910_i2c_remove.
Good catch. Mohamed, could you please fix that one up ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
