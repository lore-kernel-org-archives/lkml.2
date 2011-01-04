Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab1ADNmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:42:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48153 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750983Ab1ADNmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:42:09 -0500
Date: Tue, 4 Jan 2011 13:40:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v4 1/3] MFD MAX8998/LP3974: Support LP3974 RTC
Message-ID: <20110104134038.GB24774@opensource.wolfsonmicro.com>
References: <20101224113805.GI27832@sortiz-mobl>
 <1294118261-18906-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294118261-18906-2-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 02:17:39PM +0900, MyungJoo Ham wrote:
> The first releases of LP3974 have a large delay in RTC registers,
> which requires 2 seconds of delay after writing to a rtc register
> (recommended by National Semiconductor's engineers)
> before reading it.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
