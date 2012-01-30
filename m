Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab2A3Klo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:41:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61765 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2A3Kln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:41:43 -0500
Message-ID: <4F26739F.2070305@mvista.com>
Date: Mon, 30 Jan 2012 14:40:31 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 3/3] arm: da830: move NAND and NOR devices as aemif
 MFD slaves
References: <1327487156-10238-1-git-send-email-prakash.pm@ti.com> <1327487156-10238-3-git-send-email-prakash.pm@ti.com> <4F2016F4.2080302@mvista.com> <A73F36158E33644199EB82C5EC81C7BC3175BD35@DBDE01.ent.ti.com>
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3175BD35@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 30-01-2012 10:58, Manjunathappa, Prakash wrote:

>>> NAND and NOR device are made as aemif devices slave, hence device
>>> registration achieved via aemif MFD driver.

>>> Signed-off-by: Manjunathappa, Prakash<prakash.pm@ti.com>
>>> ---
>>> Since v1:
>>> Patch is generated using -M option.

>>>    arch/arm/mach-davinci/board-da830-evm.c |   31 +++++++++++++++++++++++--------
>>>    1 files changed, 23 insertions(+), 8 deletions(-)

>>      Why only this file? Don't other board files have NAND/NOR devices?

> Yes I thought of sending board-da850 changes in separate patch. Should I have to send those changes also in this patch?

    There's also board-dm*.c files. I'd done them all in the same patch.

> Thanks,
> Prakash

WBR, Sergei
