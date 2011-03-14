Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1CNLXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:23:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:18302 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab1CNLXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:23:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,315,1297065600"; 
   d="scan'208";a="666998368"
Date: Mon, 14 Mar 2011 12:23:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: johnpol@2ka.mipt.ru, a.zummo@towertech.it, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, dmitry.torokhov@gmail.com,
        dtor@mail.ru, rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: adopt mfd_data in 88pm860x led
Message-ID: <20110314112303.GG31153@sortiz-mobl>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Mon, Mar 07, 2011 at 11:43:10PM +0800, Haojian Zhuang wrote:
> Copy 88pm860x platform data into different mfd_data structure for
> led driver. So move the identification of device node from led
> driver to mfd driver.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
