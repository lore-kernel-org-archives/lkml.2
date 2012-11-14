Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2KNI57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:57:59 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45359 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2KNI56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:57:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121114084105.GG7407@opensource.wolfsonmicro.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
	<CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
	<20121114072855.GF7407@opensource.wolfsonmicro.com>
	<CADz5_gLb5ZRHLZHw1sDDWzu4QgOR7JXnaRMEXxETNzVsu1Wq1A@mail.gmail.com>
	<20121114084105.GG7407@opensource.wolfsonmicro.com>
Date: Wed, 14 Nov 2012 16:57:56 +0800
Message-ID: <CADz5_gJDHeZNoWRF18YJKY3kT1vN0=d-eLcP1wgWxYhLNnbpDQ@mail.gmail.com>
Subject: Re: FW: [PATCH v2] mmc: sdhci: apply voltage range check only for
 non-fixed regulators
From: Kevin Liu <keyuan.liu@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: m.szyprowski@samsung.com, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, lrg@ti.com,
        Philip Rakity <prakity@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Nov 14, 2012 at 04:36:28PM +0800, Kevin Liu wrote:
>> 2012/11/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
>> > Should this be regulator_set_voltage_tol()?  Otherwise it'd be good to
>> > explain where the numbers come from.
>
>> In SD physical layer spec 3.01 chapter 6.6.1, the threshold level for
>> voltage range is defined as below:
>> Vdd(min) = 2.7V while Vdd(max) = 3.6V.
>> The card should work within the voltage range.
>
>> If you are afraid the voltage value is too aggressive, maybe we can
>> use regulator_set_voltage_tol() to set a smaller range.
>> But which range should be reasonable?
>
> The above makes total sense - thanks!  I just wasn't aware that the
> range was specified in this fashion in the spec.  Might be worth a
> comment in the code if you need to respin.

Sure, I will update the patch. Thanks!
