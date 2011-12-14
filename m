Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1LNHE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:04:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39758 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab1LNHEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:04:23 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-cb-4ee84a76fe74
From: Chanho Park <chanho61.park@samsung.com>
To: "'Linus Walleij'" <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Cc: "'Stephen Warren'" <swarren@nvidia.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Barry Song'" <21cnbao@gmail.com>,
        "'Shawn Guo'" <shawn.guo@freescale.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Dong Aisheng'" <dong.aisheng@linaro.org>,
        "'Rajendra Nayak'" <rajendra.nayak@linaro.org>,
        "'Haojian Zhuang'" <haojian.zhuang@marvell.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
In-reply-to: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
Subject: RE: [PATCH v6] pinctrl: add a pin config interface
Date: Wed, 14 Dec 2011 16:04:22 +0900
Message-id: <010201ccba2e$9b4564e0$d1d02ea0$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acy2aduow2iQUdYZSC+LK4LEvvgcDADwWsOg
Content-language: ko
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ChangeLog v5->v6:
> - Change to using a pin name as parameter for the
>   [get|set]_config() functions, as suggested by Stephen Warren.
>   This is more natural as names will be what a developer has
>   access to in written documentation etc.


I don't agree with it.
Someone doesn't like to assign a pin name individually because a
pin number is sufficient to represent each pin.
We also provide a macro to define a anonymous pin descriptor.

/* Convenience macro to define a single named or anonymous pin descriptor */
#define PINCTRL_PIN(a, b) { .number = a, .name = b }
#define PINCTRL_PIN_ANON(a) { .number = a }

If we use only the pin name for [get|set]_config(), we must assign the name
of all pins.
IMHO, we also provide pin numbers to control anonymous pins.

--
Best Regards,
Chanho Park

