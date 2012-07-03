Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2GCNsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:48:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34721 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab2GCNsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:48:32 -0400
Message-ID: <4FF2F82D.9080507@linaro.org>
Date: Tue, 03 Jul 2012 14:48:29 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org> <20120703123552.GC25995@sirena.org.uk> <4FF2EEA1.6080204@linaro.org> <20120703132447.GN29030@opensource.wolfsonmicro.com>
In-Reply-To: <20120703132447.GN29030@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/12 14:24, Mark Brown wrote:
> On Tue, Jul 03, 2012 at 02:07:45PM +0100, Lee Jones wrote:
>> On 03/07/12 13:35, Mark Brown wrote:
>
>>> Do we really want to create MFD cells like this (which are really Linux
>>> internal things and might vary if another OS or another version of Linux
>>> changes its internal abstractions) from the device tree?
>
>> We're not creating them. We're merely using current infrastructure.
>
> *Very* recently added infrastructure which caused you to notice this...

No, I mean the MFD method is current infrastructure.

Using it with DT is new, yes.

>> Before, when we probed each device from Device Tree we came up
>> against some fairly major limitations of the Device Tree. As a
>> result, Arnd and I agreed that this was the way to go.
>
> I'm really unconvinced that instnatiating the MFD cells from device tree
> is in general a good idea.

Well it just doesn't work the other way.

>> See c5395e7ed8f16cc7bb72a783de68659db5aed515 for a short description
>> of the troubles we faced.
>
> $ git show c5395e7ed8f16cc7bb72a783de68659db5aed515
> fatal: bad object c5395e7ed8f16cc7bb72a783de68659db5aed515

Sorry, looks live I've rebased since.

5f3fc8adeec9bb12742fbfa777fa1947deda21a2

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


