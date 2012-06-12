Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab2FLHuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:50:32 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47905 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2FLHub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:50:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAF+7xW=UR4qXg9Pu4aMtHPYP6ATyvqwkW1wY=E2VvdmT6SAScQ@mail.gmail.com>
References: <000c01cd4766$b013b410$103b1c30$%han@samsung.com> <CAF+7xW=UR4qXg9Pu4aMtHPYP6ATyvqwkW1wY=E2VvdmT6SAScQ@mail.gmail.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 12 Jun 2012 09:50:10 +0200
Message-ID: <CAH9NwWf5MMEji0FqJognmaYC1153MY8=JL1gNO_uZgnUkYqUVw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3][RESEND] backlight: ot200_bl: use devm_ functions
To: axel.lin@gmail.com
Cc: Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/12 Axel Lin <axel.lin@gmail.com>:
>>  error_mfgpt_alloc:
>>        gpio_free(GPIO_DIMM);
>
> You can also use devm_gpio_request, so you can remove gpio_free here
> and remove the gpio_free in ot200_backlight_remove().

nice catch
