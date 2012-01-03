Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2ACTuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:50:16 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62947 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438Ab2ACTuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:50:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMiN_yOxDT1Xrn3LOU+D027+oC3fxTPkph-WzpVPE-86Mg@mail.gmail.com>
References: <1325616276-10304-1-git-send-email-sjg@chromium.org>
	<CAOesGMiN_yOxDT1Xrn3LOU+D027+oC3fxTPkph-WzpVPE-86Mg@mail.gmail.com>
Date: Tue, 3 Jan 2012 11:50:13 -0800
X-Google-Sender-Auth: bxnGA6Oj6E3yi7GpUWIeq0v1x0M
Message-ID: <CAPnjgZ31hQS35Zq6Mb+cc770vabgtwNYqJoEySbbG-JKGahPnQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: Remove BUILD_BUG_ON from asm/bug.h
From: Simon Glass <sjg@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, Olof Johansson <olofj@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Tue, Jan 3, 2012 at 11:39 AM, Olof Johansson <olof@lixom.net> wrote:
> On Tue, Jan 3, 2012 at 10:44 AM, Simon Glass <sjg@chromium.org> wrote:
>> BUILD_BUG_ON is defined in linux/kernel.h but that is not included by the
>> asm/bug.h header which uses it. This causes a build error:
>>
>> ...include/linux/mtd/map.h: In function 'inline_map_read':
>> ...include/linux/mtd/map.h:408:3: error: implicit declaration of function
>> 'BUILD_BUG_ON' [-Werror=implicit-function-declaration]
>>
>> The check is not essential and is not present for other architectures, so
>> just remove it.
>>
>> Signed-off-by: Simon Glass <sjg@chromium.org>
>
> Acked-by: Olof Johansson <olof@lixom.net>
>
> Simon, have you sent it to Russell's patch tracker? If not, please do.

Done

Regards,
Simon

>
>
> -Olof
