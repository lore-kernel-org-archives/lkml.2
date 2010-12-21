Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab0LUPtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 10:49:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56892 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750816Ab0LUPtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 10:49:52 -0500
Date: Tue, 21 Dec 2010 15:50:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH] MFD MAX8998/LP3974: Add Features: hibernation,
 charger, and other misc.
Message-ID: <20101221155004.GA21871@opensource.wolfsonmicro.com>
References: <1292898128-32647-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292898128-32647-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 11:22:08AM +0900, MyungJoo Ham wrote:
> 1. Hibernation support
> 2. Charger support
> 3. Support LP3974 RTC.
> 4. Support wider ranges for DVS-GPIO

This would be much easier to review if each of these changes were split
out into a separate patch - at the minute all the code changes are mixed
in with each other.
