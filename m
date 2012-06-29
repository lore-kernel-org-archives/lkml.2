Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab2F2QF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:05:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:47477 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab2F2QF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:05:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159763528"
Date: Fri, 29 Jun 2012 18:17:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: max8925: transfer rtc irq in resources
Message-ID: <20120629161705.GP22806@sortiz-mobl>
References: <1338890930-24724-1-git-send-email-haojian.zhuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338890930-24724-1-git-send-email-haojian.zhuang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Tue, Jun 05, 2012 at 06:08:50PM +0800, Haojian Zhuang wrote:
> MAX8925 rtc irq is transfered from mfd resources now.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
>  drivers/mfd/max8925-core.c |    8 ++++----
>  drivers/rtc/rtc-max8925.c  |   13 +++++++------
>  2 files changed, 11 insertions(+), 10 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
