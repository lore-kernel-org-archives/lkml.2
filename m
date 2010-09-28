Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab0I1KPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:15:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39594 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682Ab0I1KPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:15:03 -0400
Message-ID: <4CA1BFBF.2090102@mvista.com>
Date: Tue, 28 Sep 2010 14:13:19 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        khilman@deeprootsystems.com, linux@arm.linux.org.uk,
        linux kernel <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 1/3] ARM: add CPPI 4.1 DMA support
References: <201005152214.53993.sshtylyov@ru.mvista.com> <AANLkTinuQsSP1EHWn5DS_9PMrsgj+fpjLOOkpnnBaf8Q@mail.gmail.com>
In-Reply-To: <AANLkTinuQsSP1EHWn5DS_9PMrsgj+fpjLOOkpnnBaf8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-09-2010 13:13, Linus Walleij wrote:

>> Add support for Texas Instuments Communication Port Programming Interface 4.1
>> (CPPI 4.1) used on OMAP-L1x/DA8xx and AM35x.

> Sorry for late feedback ...

>> +++ linux-davinci/arch/arm/common/cppi41.c

> Can you migrate this driver to drivers/dma/cppi41.c and use the
> DMAengine interface like so many DMA drivers we have created
> recently, or is there some very special characteristics about this
> DMA controller meriting it to be placed in arch/arm/*?

    I have once studied the possibility of doing this driver under 
drivers/dma/, and found that hardly achievable. Maybe I should try again though...

> Yours,
> Linus Walleij

WBR, Sergei
