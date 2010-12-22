Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0LVNZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:25:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54079 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750764Ab0LVNZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:25:23 -0500
Date: Wed, 22 Dec 2010 13:25:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 2/6] MFD MAX8998/LP3974: Support LP3974 RTC
Message-ID: <20101222132534.GB26306@opensource.wolfsonmicro.com>
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
 <1292998991-26968-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292998991-26968-3-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 03:23:07PM +0900, MyungJoo Ham wrote:

> before reading it. If the device name is "lp3974-regerr", the rtc driver
> assumes that such delays are required. If the device name is "lp3974",
> the rtc driver does not. Although we have not seen LP3974s without
> requiring such delays, we assume that such LP3974s will be released
> soon (or they have done so already) and they are supported by "lp3974".

Might a bit of platform data not be a more robust way of passing this
in?  If we use the device name then it'd be difficult to handle other
issues in future.

It's a shame the affected devices can't be identified at runtime :(
