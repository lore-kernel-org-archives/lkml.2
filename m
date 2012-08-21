Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab2HUDhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 23:37:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59959 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2HUDhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 23:37:03 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <50325153.3000305@wwwdotorg.org>
References: <1345271585.7986.0.camel@phoenix> <50325153.3000305@wwwdotorg.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 21 Aug 2012 11:36:42 +0800
Message-ID: <CAF+7xW=PO_j=CT7o5LPH7L-WF_Vg9D+6YgYcfEsxRy8VT27Ckw@mail.gmail.com>
Subject: Re: [PATCH] regulator: max8907: Properly set pmic pointer in max8907_regulator_remove()
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/20 Stephen Warren <swarren@wwwdotorg.org>:
> On 08/18/2012 12:33 AM, Axel Lin wrote:
>> Add missing platform_get_drvdata() call in max8907_regulator_remove(), this
>> fixes below build warning:
>>
>>   CC [M]  drivers/regulator/max8907-regulator.o
>> drivers/regulator/max8907-regulator.c: In function 'max8907_regulator_remove':
>> drivers/regulator/max8907-regulator.c:353:23: warning: 'pmic' is used uninitialized in this function [-Wuninitialized]
>
> That's odd; while this warning and the patch are obviously correct, I
> can't get my compiler to warn about it at all, and it usually is pretty
> strict about emitting warnings. Oh well.

I got this error message only when I compile it as a module. :-)

Axel
