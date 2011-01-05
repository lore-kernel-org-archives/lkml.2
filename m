Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab1AEFYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 00:24:25 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:29889 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802Ab1AEFYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 00:24:24 -0500
Message-ID: <A806957B89494BCC9C6E56726BFC5DE8@hacdom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>,
        <yong.y.wang@intel.com>, <qi.wang@intel.com>,
        <linux-kernel@vger.kernel.org>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "Marc Zyngier" <maz@misterjones.org>,
        "Rabin Vincent" <rabin.vincent@stericsson.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>
References: <1293105524-3250-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20110103134004.04814deb.akpm@linux-foundation.org>
Subject: Re: [PATCH] gpio/ml_ioh_gpio: ML7213 GPIO driver
Date: Wed, 5 Jan 2011 14:24:19 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tuesday, January 04, 2011 6:40 AM, Andrew Morton wrote:
>> + for (i = 0, chip = chip_save; i < 8; i++, chip++) {
> 
> chip = chip_save;
> for (i = 0; i < 8; i++, chip++) {
> 
> is simpler, and simpler is better.

I will modify and post the patch soon.

>> + ret = gpiochip_add(&chip->gpio);
>> + if (ret) {
>> + dev_err(&pdev->dev, "IOH gpio: Failed to register GPIO\n");
>> + goto err_gpiochip_add;
> 
> Here we should run gpiochip_remove() against chips 0 .. i-1, no?

Yes, you are right.
I will modify and post the patch soon.


Thanks,,
---
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
