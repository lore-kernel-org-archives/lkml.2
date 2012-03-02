Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2CBAvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:51:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49709 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2CBAva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:51:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.222.194 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120301101502.GB2535@pengutronix.de>
References: <1329725656-32715-1-git-send-email-alexander.stein@systec-electronic.com>
	<20120224121753.GE2479@pengutronix.de>
	<CANKRQngWB8kUO68UdbDeWey5eGRF0nGCE341j8jyCMogvYUYKA@mail.gmail.com>
	<20120301101502.GB2535@pengutronix.de>
Date: Fri, 2 Mar 2012 09:51:29 +0900
Message-ID: <CANKRQniA2icHddFG22r7VtLTuoefbK61tpcUQnXgShFHuffUuA@mail.gmail.com>
Subject: Re: [PATCH v2] i2c-eg20t: Rework pch_i2c_wait_for_bus_idle to reduce
 wait time
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Feng Tang <feng.tang@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年3月1日19:15 Wolfram Sang <w.sang@pengutronix.de>:
> Ah, thanks for the update! Are you fine with the patch in question now?

Alexander's patch looks good.
Did Alexander test i2c-eg20t driver with this patch ?

thanks,
-- 
ROHM Co., Ltd.
tomoya
