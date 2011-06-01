Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab1FAOyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:54:21 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:55727 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757607Ab1FAOyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:54:20 -0400
Message-ID: <4DE64E67.2020507@stericsson.com>
Date: Wed, 1 Jun 2011 16:36:23 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
References: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com> <alpine.LFD.2.02.1105311236250.3078@ionos> <4DE51EB7.7010606@stericsson.com> <BANLkTinPKbUu40066+wr3cdFRc2di-Uv6g@mail.gmail.com> <4DE5F0DB.2050409@stericsson.com> <4DE64B0E.8030008@stericsson.com> <20110601142507.GK3660@n2100.arm.linux.org.uk> <4DE64D5A.20206@stericsson.com>
In-Reply-To: <4DE64D5A.20206@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 04:31 PM, Mattias Wallin wrote:
> On 06/01/2011 04:25 PM, Russell King - ARM Linux wrote:
>> sched_clock is supposed to be setup and initialized really early.  Why
>> are you doing trying to move it soo late?
> Linus idea was to remove the dependency from mach-ux500/cpu.c where I
> originally called the init function by using core_initcall.
>
> Should I use pure_initcall or solve it some other way?
pure_initcall does not work either.
