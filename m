Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3AIGa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:30:29 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40240 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3AIGa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:30:28 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1357712039.774.0.camel@gitbox>
References: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
	<1356650452-16559-2-git-send-email-linux@prisktech.co.nz>
	<1357712039.774.0.camel@gitbox>
Date: Tue, 8 Jan 2013 22:30:27 -0800
Message-ID: <CAOesGMj6XTuW9tPqYnawPvO-wJBd7s5M5xTfdvQcmEioHw=Pnw@mail.gmail.com>
Subject: Re: [PATCH 1/4] arm: vt8500: Add support for Wondermedia WM8750/WM8850
From: Olof Johansson <olof@lixom.net>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 10:13 PM, Tony Prisk <linux@prisktech.co.nz> wrote:
> On Fri, 2012-12-28 at 12:20 +1300, Tony Prisk wrote:
>> This patch adds support for the WM8750 (ARMv6) and WM8850 (ARMv7).
>>
>> Common features across all SoCs are split into ARCH_VT8500 and
>> unique features are specified by each SoC option.
>>
>> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
>
>
> Hi Arnd, Olof,
>
> Haven't heard anything re: this patch series. Problem?

Nope, just wasn't sure if you would send a git pull request or if you
wanted them applied.

I'm out of time for tonight, but I'll look closer at them (and apply
them if all OK) tomorrow.


-Olof
