Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab1KOW0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:26:34 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38700 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1KOW0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:26:32 -0500
MIME-Version: 1.0
In-Reply-To: <20111115.164134.1813312136000862195.davem@davemloft.net>
References: <1321377163-26308-1-git-send-email-grundler@chromium.org>
	<20111115.164134.1813312136000862195.davem@davemloft.net>
Date: Tue, 15 Nov 2011 14:26:32 -0800
X-Google-Sender-Auth: cZMdEXPYJwLgq3jRBIPdHsLaSF0
Message-ID: <CANEJEGt3iR1q-2200L1gAYhha4uatPKRche5dAS4bzSVm5bjTA@mail.gmail.com>
Subject: Re: [PATCH 1/5] net-next:asix:PHY_MODE_RTL8211CL should be 0xC
From: Grant Grundler <grundler@chromium.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, allan@asix.com.tw,
        freddy@asix.com.tw
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 1:41 PM, David Miller <davem@davemloft.net> wrote:
> From: Grant Grundler <grundler@chromium.org>
> Date: Tue, 15 Nov 2011 09:12:39 -0800
>
>> From: Grant Grundler <grundler@google.com>
>>
>> Use correct value for rtl phy support.
>> (rtl phy are in AX88178 devices like NWU220G and USB2-ET1000).
>>
>> Signed-off-by: Allan Chou <allan@asix.com.tw>
>> Tested-by: Grant Grundler <grundler@chromium.org>
>
> Applied.

Dave,
Thanks for applying the series and offering to push immediately to
linus. I'll submit the white space/coding style clean ups after the
frustration of my blooper has receded from your memory a bit more. :)

cheers,
grant
