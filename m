Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1DZI7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:59:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:49587 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab1DZI7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:59:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="634156166"
Date: Tue, 26 Apr 2011 10:58:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, a.zummo@towertech.it, johnpol@2ka.mipt.ru,
        cbou@mail.ru, dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 03/14] rtc: add 88pm860x rtc
Message-ID: <20110426085855.GB2659@sortiz-mobl>
References: <2011041801>
 <1303135451-26362-4-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303135451-26362-4-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Mon, Apr 18, 2011 at 10:04:00PM +0800, Haojian Zhuang wrote:
> Support RTC component in 88PM860x. Also support synchronize time from
> 88PM860x RTC to another RTC device. It should be implemented in
> sync callback API.
> 
> While 88PM860x RTC is enabled, it can do RTC calibration to gurantee
> enough power is supplied on VRTC domain of 88PM860x.
For the MFD part:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
