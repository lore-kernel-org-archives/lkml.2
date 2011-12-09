Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1LIKdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:33:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46516 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1LIKc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:32:58 -0500
MIME-Version: 1.0
In-Reply-To: <1322556599-28616-1-git-send-email-dg77.kim@samsung.com>
References: <1322556599-28616-1-git-send-email-dg77.kim@samsung.com>
Date: Fri, 9 Dec 2011 19:32:57 +0900
X-Google-Sender-Auth: dYqZgoXasQ4d0BW2ek2upa7oZLg
Message-ID: <CAH9JG2WicecDD-+EEgk4vq-4ynuZMunjtsWq2LWpW8QNrauCJA@mail.gmail.com>
Subject: Re: [PATCH 0/2] leds: add MAX8997-LED driver
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, rpurdie@rpsys.net,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel & Richard,

Now we're implement the maxim PMIC features has several devices integrated.
Some parts are already merged and wait for review.

To make it review and merge easy, It will make a maxim branch.
How do you think?

Thank you,
Kyungmin Park

On 11/29/11, Donggeun Kim <dg77.kim@samsung.com> wrote:
> MAX8997 integrates serveral features in a single chip.
> It includes PMIC (Power Management IC), RTC, charger, fuel gauge,
> LED driver, and so on.
> This patchset supports unimplemented LED driver of MAX8997.
>
> Donggeun Kim (2):
>   MFD: MAX8997: add platform data and devices for LED control
>   leds: add suuport for MAX8997-LED driver
>
>  drivers/leds/Kconfig        |    7 +
>  drivers/leds/Makefile       |    1 +
>  drivers/leds/leds-max8997.c |  373
> +++++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/max8997.c       |    2 +
>  include/linux/mfd/max8997.h |   25 +++-
>  5 files changed, 407 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/leds/leds-max8997.c
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
