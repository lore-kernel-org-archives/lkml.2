Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab2E0LiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 07:38:06 -0400
Received: from antcom.de ([188.40.178.216]:58111 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab2E0LiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 07:38:03 -0400
Message-ID: <4FC21214.7060804@antcom.de>
Date: Sun, 27 May 2012 13:37:56 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC] serial/8250: Adjusting FIFO parameters for LPC32xx
References: <1338048678-23991-1-git-send-email-stigge@antcom.de> <201205270232.58253.arnd@arndb.de> <4FC1EEA7.2060109@antcom.de> <201205271023.16742.arnd@arndb.de>
In-Reply-To: <201205271023.16742.arnd@arndb.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/05/12 12:23, Arnd Bergmann wrote:
>> --- a/drivers/tty/serial/of_serial.c
>> +++ b/drivers/tty/serial/of_serial.c
>> @@ -179,6 +179,7 @@ static struct of_device_id __devinitdata of_platform_serial_table[] = {
>>         { .compatible = "ns16450",  .data = (void *)PORT_16450, },
>>         { .compatible = "ns16550a", .data = (void *)PORT_16550A, },
>>         { .compatible = "ns16550",  .data = (void *)PORT_16550, },
>> +       { .compatible = "ns16654",  .data = (void *)PORT_16654, },
>>         { .compatible = "ns16750",  .data = (void *)PORT_16750, },
>>         { .compatible = "ns16850",  .data = (void *)PORT_16850, },
>>         { .compatible = "nvidia,tegra20-uart", .data = (void *)PORT_TEGRA, },
>>
>> Wondering if it should rather be .compatible = "st16654"?
>> Will prepare a patch with adjustment of Documentation/.../of-serial.txt when
>> we agree on sth.
> 
> I think st16654 would be better than ns16654 here, yes.

OK, will provide a patch accordingly.

> Actually some of the other entries are wrong, too. The ns8250 entry should
> be i8250, and I guess the 16750 and 16850 were also not made by national.

But maybe we should keep the existing compatible strings because
existing boards/bootloaders are providing them already?

Roland
