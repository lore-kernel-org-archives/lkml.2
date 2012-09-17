Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2IQK2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:28:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60798 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2IQK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:28:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120917101914.GA5401@opensource.wolfsonmicro.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
	<1347855552-26213-4-git-send-email-haojian.zhuang@gmail.com>
	<20120917101914.GA5401@opensource.wolfsonmicro.com>
Date: Mon, 17 Sep 2012 18:28:18 +0800
Message-ID: <CAN1soZzTr-Zm0J41KXjnPei_9DtLF86fQbMpWyZzG9x=CWetiA@mail.gmail.com>
Subject: Re: [PATCH 3/9] regulator: 88pm860x: add pre-regulator support for
 88pm860x regulator
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, lrg@ti.com, rpurdie@rpsys.net,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        "Jett.Zhou" <jtzhou@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 6:19 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Sep 17, 2012 at 12:19:06PM +0800, Haojian Zhuang wrote:
>> From: "Jett.Zhou" <jtzhou@marvell.com>
>>
>> Pre-regulator of 88pm8606 is mainly for support charging based on vbus,
>> it needs to be enabled for charging battery, and will be disabled in
>> some exception condition like over-temp.
>> Add the pre-regulator support for 88pm860x regulator driver.
>>
>> Signed-off-by: Jett.Zhou <jtzhou@marvell.com>
>> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
>
> If you can sign this patch off I can apply it.

Could this patch be merged into MFD tree? Since the fourth patch in this
patch series is depend on this one.

Best Regards
Haojian

From: Haojian Zhuang <haojian.zhuang@marvell.com>

Since PREG regulator is the only one regulator in 88PM8606, and other
regulators are in 88PM8607. Checking resource as identifying regulator
is not a good way. We can use NULL resource to indentify PREG regulator.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/88pm860x-core.c  |    8 +-------
 drivers/regulator/88pm8607.c |   32 +++++++++++++++++++-------------
 2 files changed, 20 insertions(+), 20 deletions(-)
