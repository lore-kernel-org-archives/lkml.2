Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366Ab2CMST0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:19:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51794 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729Ab2CMSTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:19:24 -0400
Date: Tue, 13 Mar 2012 22:19:18 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, dg77.kim@samsung.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Jason.Wortham@maxim-ic.com, bruce.e.robertson@intel.com
Subject: Re: [PATCH 4/5] max17042: Fix value scaling for VCELL and avgVCELL
Message-ID: <20120313181918.GA15964@oksana.dev.rtsoft.ru>
References: <1327425968-21195-1-git-send-email-dirk.brandewie@gmail.com>
 <1327425968-21195-5-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1327425968-21195-5-git-send-email-dirk.brandewie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 09:26:07AM -0800, dirk.brandewie@gmail.com wrote:
> From: Bruce Robertson <bruce.e.robertson@intel.com>
> 
> The bottom three bits of the register are don't care bits.  The LSB
> value is 625 uV.  Adjust the returned values appropriately
> 
> Signed-off-by: Bruce Robertson <bruce.e.robertson@intel.com>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

I guess this was fixed long ago by the following patch:

commit cf7a8c03db792894f436db5f3ffc44d947b9b068
Author: MyungJoo Ham <myungjoo.ham@samsung.com>
Date:   Wed Aug 17 10:18:34 2011 +0900

    max17042_battery: Bugfix of incorrect voltage register value interpretation

    The calculation had error in getting voltage values from
    MAX17042 registers. The least bit denotes 78.125uV (625/8).

    Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
    Signed-off-by: Philip Rakity <prakity@marvell.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
