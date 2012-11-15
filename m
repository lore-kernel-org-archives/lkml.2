Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2KOGhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:37:39 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:33061 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2KOGhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:37:37 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdb-C-z1bWA2+xbuGt8TKSWRaD2xYUKS4M=KNMO0mOKF2g@mail.gmail.com>
References: <1352460548-3494-1-git-send-email-hongbo.zhang@linaro.com>
	<1352460548-3494-3-git-send-email-hongbo.zhang@linaro.com>
	<1352700425.1834.11.camel@rzhang1-mobl4>
	<CACRpkdb-C-z1bWA2+xbuGt8TKSWRaD2xYUKS4M=KNMO0mOKF2g@mail.gmail.com>
Date: Thu, 15 Nov 2012 14:37:36 +0800
Message-ID: <CAJLyvQwhtL3cpb_7Xa25hmQ-Yg4inEF1umaC8rr04A-3x79LAw@mail.gmail.com>
Subject: Re: [PATCH V5 2/2] Thermal: Add ST-Ericsson DB8500 thermal properties
 and platform data.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-pm@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2012 04:46, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Nov 12, 2012 at 7:07 AM, Zhang Rui <rui.zhang@intel.com> wrote:
>> On Fri, 2012-11-09 at 19:29 +0800, hongbo.zhang wrote:
>>> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>>>
>>> This patch adds device tree properties for ST-Ericsson DB8500 thermal driver,
>>> also adds the platform data to support the old fashion.
>>>
>>> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
>>> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
>>
>> hmmm,
>>
>> who should take this patch?
>> I'd like to see ACK from the maintainer of these code before applying
>> them to thermal tree.
>
> I guess it needs to go through Thermal.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thank you Linus Walleij.

Hi Rui, I got it.

> Let's hope it's not creating too much conflict...
>
> Yours,
> Linus Walleij
