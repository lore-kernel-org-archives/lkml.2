Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1ELPOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:14:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56042 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1ELPOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=i3cj6zIpI/KFhfv2tvLzjDCUGnIfWGI/OPmQa4bW7McmFAUpMHEaUH0Y8JETZr1z9c
         pMnaSPnSbdtKG6qGsjP0XYy5OUA5u7xWaT7F7JCH0/qRRGRGKN+iT5H51nzB2FCmO4on
         3HkaiVVjYuq5Xbid+s448wG6COV8oFz2c+XkU=
MIME-Version: 1.0
In-Reply-To: <AANLkTikkcYw66MiJO9Bpm+De=XD2-1MFxm-CUPp6sMqL@mail.gmail.com>
References: <1290060899-9786-1-git-send-email-ccross@android.com>
	<AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
	<4D70BE9D.4000507@stericsson.com>
	<AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com>
	<4D714C17.7080102@gmail.com>
	<AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com>
	<eea425c066cc69c30f118fb102fff43e@mail.gmail.com>
	<AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com>
	<7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com>
	<AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com>
	<AANLkTikkcYw66MiJO9Bpm+De=XD2-1MFxm-CUPp6sMqL@mail.gmail.com>
Date: Thu, 12 May 2011 17:14:49 +0200
X-Google-Sender-Auth: xK5XMaCuJG6Qyt6uPw4egVhpF88
Message-ID: <BANLkTi=-T6P0KrsQ8+Ot_inq1JabY62LvA@mail.gmail.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency withcpufreqnotifiers
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Colin Cross <ccross@android.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        martin persson <martin.persson@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/6 Linus Walleij <linus.walleij@linaro.org>:
> On Sun, Mar 6, 2011 at 6:42 PM, Colin Cross <ccross@android.com> wrote:
>
>> Is there any way
>> for a clockevent to invalidate the current event and ask for it to be
>> reprogrammed?
>
> TGLX will know for sure... Thomas?
>
> (This is inside a CPUfreq hook for a localtimer for the record.)

I discussed this briefly with TGLX at the UDS here and he's confident
we could add some nifty feature to reprogram an event. I dare not
try to guess where the code would sit or how it'd look...

Yours,
Linus Walleij
