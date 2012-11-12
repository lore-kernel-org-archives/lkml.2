Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2KLMXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 07:23:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63280 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab2KLMX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:23:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAHTX3dLjz=WMX_YtRQSwfUDFt1=yMoTeWd7mfqhxi1-TkSggfQ@mail.gmail.com>
References: <20121105212426.GA1972@beefymiracle.amer.corp.natinst.com>
	<CAHTX3dLjz=WMX_YtRQSwfUDFt1=yMoTeWd7mfqhxi1-TkSggfQ@mail.gmail.com>
Date: Mon, 12 Nov 2012 13:23:25 +0100
Message-ID: <CAHTX3d+_qymejtA3tG7UVBid=7frnnJFTiZPzKuPhPyZd-m-wg@mail.gmail.com>
Subject: Re: [PATCH v2] serial: xilinx_uartps: kill CONFIG_OF conditional
From: Michal Simek <monstr@monstr.eu>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/7 Michal Simek <monstr@monstr.eu>:
> 2012/11/5 Josh Cartwright <josh.cartwright@ni.com>:
>> The Zynq platform requires the use of CONFIG_OF.  Remove the #ifdef
>> conditionals in the uartps driver.  Make dependency explicit in Kconfig.
>>
>> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
>> ---
>> Michal-
>>
>> Here's a version of this patch outside of my COMMON_CLK patchset as you
>> requested ontop of your arm-next branch.  An explicit dependency was
>> added in Kconfig as you had suggested.
>>
>> Thanks,
>>    Josh
>>
>>  drivers/tty/serial/Kconfig         | 1 +
>>  drivers/tty/serial/xilinx_uartps.c | 9 ---------
>>  2 files changed, 1 insertion(+), 9 deletions(-)
>
> Tested-by: Michal Simek <monstr@monstr.eu>
>

Greg: Can you please add this patch to your tree?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
