Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750826Ab1HIN0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:26:54 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:56029 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1HIN0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:26:53 -0400
MIME-Version: 1.0
In-Reply-To: <87zklstbtf.fsf@devron.myhome.or.jp>
References: <1307550963-26352-1-git-send-email-linus.walleij@stericsson.com>
	<87zklstbtf.fsf@devron.myhome.or.jp>
Date: Tue, 9 Aug 2011 15:26:53 +0200
X-Google-Sender-Auth: cF_ps_qNFiMLmLuhxHmpsdxuRw4
Message-ID: <CAKnu2MpPy+==NtQRF2c4EAf53Ry6w=+NxSHvv4i0QE+L-7U53w@mail.gmail.com>
Subject: Re: [PATCH] fs/fat: fix build warning
From: Linus Walleij <linus.walleij@linaro.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jonas Aberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/8 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:

> Linus Walleij <linus.walleij@stericsson.com> writes:
>
>> From: Jonas Aberg <jonas.aberg@stericsson.com>
>>
>> This fixes a compile warning (unititialized variable) in
>> the fat filesystem code.
>
> Thanks. I'll apply.

Hirofumi, I cannot see this fix in the mainline kernel as of v3.1-rc1.
Has it slipped out?

Thanks,
Linus Walleij
