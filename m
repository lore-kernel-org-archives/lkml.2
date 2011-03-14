Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1CNKvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:51:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:40681 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab1CNKvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:51:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,315,1297065600"; 
   d="scan'208";a="666990615"
Date: Mon, 14 Mar 2011 11:51:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: johnpol@2ka.mipt.ru, a.zummo@towertech.it, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, dmitry.torokhov@gmail.com,
        dtor@mail.ru, rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: add 88pm860x rtc
Message-ID: <20110314105118.GE31153@sortiz-mobl>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-7-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-8-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-9-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299512600-29047-9-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Mon, Mar 07, 2011 at 11:43:17PM +0800, Haojian Zhuang wrote:
> Support RTC component in 88PM860x. Also support synchronize time
> 88PM860x RTC to another RTC device. It should be implemented in
> sync callback API.
> 
> While 88PM860x RTC is enabled, it can do RTC calibration to gurantee
> enough power is supplied on VRTC domain of 88PM860x.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> ---
>  drivers/mfd/88pm860x-core.c  |   30 ++++++++++++++++++++++++++++++
>  drivers/rtc/Kconfig          |   10 ++++++++++
>  drivers/rtc/Makefile         |    1 +
>  include/linux/mfd/88pm860x.h |    6 ++++++
rtc-88pm860x.c is missing from this patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
