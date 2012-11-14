Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422724Ab2KNMF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:05:27 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57441 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab2KNMFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:05:25 -0500
MIME-Version: 1.0
In-Reply-To: <6D68C9EB-485C-44E8-B6C3-A988C12EFF0A@nvidia.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
	<CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
	<20121114072855.GF7407@opensource.wolfsonmicro.com>
	<CADz5_gLb5ZRHLZHw1sDDWzu4QgOR7JXnaRMEXxETNzVsu1Wq1A@mail.gmail.com>
	<20121114084105.GG7407@opensource.wolfsonmicro.com>
	<CADz5_gJDHeZNoWRF18YJKY3kT1vN0=d-eLcP1wgWxYhLNnbpDQ@mail.gmail.com>
	<6D68C9EB-485C-44E8-B6C3-A988C12EFF0A@nvidia.com>
Date: Wed, 14 Nov 2012 20:05:23 +0800
Message-ID: <CADz5_gKrcCyRe8q_x4a-K5wCFdTjD-0E8VJUktE6yvn1CaMsZA@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: sdhci: apply voltage range check only for
 non-fixed regulators
From: Kevin Liu <keyuan.liu@gmail.com>
To: Philip Rakity <prakity@nvidia.com>
Cc: Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "lrg@ti.com" <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/14 Philip Rakity <prakity@nvidia.com>:
>
> On Nov 14, 2012, at 8:57 AM, Kevin Liu <keyuan.liu@gmail.com> wrote:
>
>> 2012/11/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>>> On Wed, Nov 14, 2012 at 04:36:28PM +0800, Kevin Liu wrote:
>>>> 2012/11/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>>>
>>>>> Should this be regulator_set_voltage_tol()?  Otherwise it'd be good to
>>>>> explain where the numbers come from.
>>>
>>>> In SD physical layer spec 3.01 chapter 6.6.1, the threshold level for
>>>> voltage range is defined as below:
>>>> Vdd(min) = 2.7V while Vdd(max) = 3.6V.
>>>> The card should work within the voltage range.
>>>
>>>> If you are afraid the voltage value is too aggressive, maybe we can
>>>> use regulator_set_voltage_tol() to set a smaller range.
>>>> But which range should be reasonable?
>>>
>>> The above makes total sense - thanks!  I just wasn't aware that the
>>> range was specified in this fashion in the spec.  Might be worth a
>>> comment in the code if you need to respin.
>>
>> Sure, I will update the patch. Thanks!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> re-read spec.  Please apply Kevin;s patch.
>
> Reviewed-by: Philip Rakity <prakity@nvidia.com>

Philip, thanks!
