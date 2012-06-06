Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab2FFFx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 01:53:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59956 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2FFFx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:53:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120522215743.GF10210@sortiz-mobl>
References: <1337593907-6615-1-git-send-email-jonghwa3.lee@samsung.com>
	<1337593907-6615-2-git-send-email-jonghwa3.lee@samsung.com>
	<20120522215743.GF10210@sortiz-mobl>
Date: Wed, 6 Jun 2012 11:23:57 +0530
Message-ID: <CAKew6eW0vXDNKdO0TtPOv-z4kFnfEPKPDX5HCJ+gqXqiTjYGSg@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mfd: MAX77686: Add Maxim 77686 mfd driver
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Gridwodd <lrg@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

I want to fix bug and build error and add device tree support
in this driver, but i cann't see it in for-next branch of your tree.
Please let me know if you have queued up this patch anywhere in your tree.
Or can we review this patch and get it revised again?

Regards,
Yadwinder.

On Wed, May 23, 2012 at 3:27 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Jongwha,
>
> On Mon, May 21, 2012 at 06:51:45PM +0900, Jonghwa Lee wrote:
>> This patch is device driver for MAX77686 chip.
>> MAX77686 is PMIC and includes regulator and rtc on it.
>> This driver is core of MAX77686 chip, so provides common support for accessing
>> on-chip devices. It uses irq_domain to manage irq and regmap to read/write data
>> to its register with i2c bus.
> I'll try to push this one after rc1, or as a late merge window pull request.
>
> Cheers,
> Samuel.
>
