Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2FSMYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:24:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58082 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2FSMYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:24:12 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <CAF+7xWmFZTa8=mDW3gJwivkb0vDOj113u8bC-jP9x5BwYxFkLg@mail.gmail.com>
References: <1340092423-10073-1-git-send-email-yadi.brar@samsung.com>
 <1340092423-10073-2-git-send-email-yadi.brar@samsung.com> <CAF+7xWkopYu2CkPsdPeJ5Kr0NBbYcnf2ez-hC+RCj6QuOFcstw@mail.gmail.com>
 <CAKew6eXafa0n+dUcqa3EXEJQj4xNDM_Z2UNVhGu7rCSSEgiieQ@mail.gmail.com> <CAF+7xWmFZTa8=mDW3gJwivkb0vDOj113u8bC-jP9x5BwYxFkLg@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 19 Jun 2012 20:23:51 +0800
Message-ID: <CAF+7xW=GXWWecv5S5MerOQhrzFm=WuUWyJ0dd73B5i8aWofs3Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: max77686: Implement .set_ramp_delay() callback.
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
>                          ramp_value << 6);

Typo, should be:
        return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
                                  MAX77686_RAMP_RATE_MASK, ramp_value << 6);

>
> How do you think?
>
> Regards,
> Axel
