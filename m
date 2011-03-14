Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1CNJtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:49:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:30854 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab1CNJtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:49:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,314,1297065600"; 
   d="scan'208";a="666975788"
Date: Mon, 14 Mar 2011 10:49:12 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 0/2] MAX8997/8966 MFD (includig PMIC) Initial Release
Message-ID: <20110314094911.GA31153@sortiz-mobl>
References: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Myung,

On Fri, Mar 04, 2011 at 03:50:25PM +0900, MyungJoo Ham wrote:
> MAX8997/8966 has
> - PMIC
> - RTC
> - MUIC (usb switch)
> - Flash control
> - Haptic control
> - Fuel Gauge (MAX17042 compatible)
> - Battery charger control
> 
> This patch adds an initial driver for Maxim Semiconductor 8997/8966's
> PMIC function.
I applied patch #1 from thsi serie, thanks a lot.
Please address Mark's comments for patch #2 and I'll take it as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
