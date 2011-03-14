Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1CNLYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:24:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:46139 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab1CNLYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:24:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,315,1297065600"; 
   d="scan'208";a="897007955"
Date: Mon, 14 Mar 2011 12:24:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: johnpol@2ka.mipt.ru, a.zummo@towertech.it, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, dmitry.torokhov@gmail.com,
        dtor@mail.ru, rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: adopt mfd_data in 88pm860x
Message-ID: <20110314112420.GI31153@sortiz-mobl>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Mon, Mar 07, 2011 at 11:43:12PM +0800, Haojian Zhuang wrote:
> Copy 88pm860x platform data into different mfd_data structure for
> onkey/touch/codec/power driver. So move the identification of
> device node from those drivers to mfd driver.
I applied this patch too.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
