Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1DZJsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:48:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:28598 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab1DZJsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:48:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="914477544"
Date: Tue, 26 Apr 2011 11:48:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, a.zummo@towertech.it, johnpol@2ka.mipt.ru,
        cbou@mail.ru, dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 06/14] mfd: pxa-w1: MFD driver for PXA 1wire control +
 DS1WM chip
Message-ID: <20110426094836.GD2659@sortiz-mobl>
References: <2011041801>
 <1303135451-26362-7-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303135451-26362-7-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Mon, Apr 18, 2011 at 10:04:03PM +0800, Haojian Zhuang wrote:
> This driver provides registers and IRQ of PXA3xx chips to the ds1wm driver.
I see why this is needed, but I really think the ds1wm driver should be
converted to a regular platform device. The MFD driver below is just adding a
useless middle layer between your platform code and the ds1wm one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
