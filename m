Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab1FAXfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 19:35:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49154 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab1FAXfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 19:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HYaUGDtrlmpzhQS7NO89KlpiAbD1dTve3MgXlutU+uaiIfFGuVRDfIUOxlFv7DWxT4
         TfaLmLAFghngA2YSPW3kTwlHiXuWXg8x7oLWNVwMGGZo6KEK4vh71fU3iL2WKgNiv1t+
         yI3sd4MSceFEeHrVznUYhqVHj8/v/T65Lxn4c=
MIME-Version: 1.0
In-Reply-To: <4DE64D5A.20206@stericsson.com>
References: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com>
	<alpine.LFD.2.02.1105311236250.3078@ionos>
	<4DE51EB7.7010606@stericsson.com>
	<BANLkTinPKbUu40066+wr3cdFRc2di-Uv6g@mail.gmail.com>
	<4DE5F0DB.2050409@stericsson.com>
	<4DE64B0E.8030008@stericsson.com>
	<20110601142507.GK3660@n2100.arm.linux.org.uk>
	<4DE64D5A.20206@stericsson.com>
Date: Thu, 2 Jun 2011 01:35:07 +0200
Message-ID: <BANLkTimex7pZPHZBH4m6hhTxVMeAkL3nUA@mail.gmail.com>
Subject: Re: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/1 Mattias Wallin <mattias.wallin@stericsson.com>:
> On 06/01/2011 04:25 PM, Russell King - ARM Linux wrote:
>>
>> sched_clock is supposed to be setup and initialized really early.  Why
>> are you doing trying to move it soo late?
>
> Linus idea was to remove the dependency from mach-ux500/cpu.c where I
> originally called the init function by using core_initcall.

OK we conclude the header is needed for now methinks.

Linus Walleij
