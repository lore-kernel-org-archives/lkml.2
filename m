Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab2FLIhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:37:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38857 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2FLIhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:37:12 -0400
Message-ID: <4FD6FFB4.8080109@linaro.org>
Date: Tue, 12 Jun 2012 09:37:08 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        arnd@arndb.de, Samuel Ortiz <sameo@linux.intel.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 07/14] mfd: Initialise the AB8500 driver at core_initcall
 time
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-8-git-send-email-lee.jones@linaro.org> <CACRpkdY8aD1djSdPoeKYDdFVbf3E84ZWw2Q5CCLsPmoD66Hf7A@mail.gmail.com>
In-Reply-To: <CACRpkdY8aD1djSdPoeKYDdFVbf3E84ZWw2Q5CCLsPmoD66Hf7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/12 22:03, Linus Walleij wrote:
> On Mon, Jun 11, 2012 at 5:25 PM, Lee Jones<lee.jones@linaro.org>  wrote:
>
>> The AB8500 is soon to have its own IRQ domain. For this to be useful
>> the driver needs to be initialised earlier in the boot sequence. Here
>> we move initialisation forward from arch_initcall to core_initcall time.
>
> I don't understand why using IRQ domain makes it necessary to
> initialize the driver earlier in the init process. Please explain to me,
> I need tutoring here.

See the other email.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
