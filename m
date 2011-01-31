Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab1AaXyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:54:16 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:47062 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129Ab1AaXyP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:54:15 -0500
From: Kevin Hilman <khilman@ti.com>
To: Thomas Weber <thomas.weber.linux@googlemail.com>
Cc: Govindraj <govindraj.ti@gmail.com>, Thomas Weber <weber@corscience.de>,
        linux-omap@vger.kernel.org, manjugk@ti.com, gadiyar@ti.com,
        tony@atomide.com, govindraj@ti.com, gregkh@suse.de,
        andrei.emeltchenko@nokia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] OMAP: Enable Magic SysRq on serial console ttyOx
Organization: Texas Instruments, Inc.
References: <1295604084-27761-1-git-send-email-weber@corscience.de>
	<AANLkTikSznkcNwkVaPswx=zr8FFGQPVMw_AebF9ymZLE@mail.gmail.com>
	<8739oi7z4m.fsf@ti.com>
	<AANLkTi=HxnPVu83CpodFA4rLipcz1Oie2co49S1=+1M6@mail.gmail.com>
Date: Mon, 31 Jan 2011 15:54:11 -0800
In-Reply-To: <AANLkTi=HxnPVu83CpodFA4rLipcz1Oie2co49S1=+1M6@mail.gmail.com>
	(Thomas Weber's message of "Mon, 31 Jan 2011 22:31:09 +0100")
Message-ID: <87vd141vfg.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Weber <thomas.weber.linux@googlemail.com> writes:

> On Mon, Jan 24, 2011 at 10:47 PM, Kevin Hilman <khilman@ti.com> wrote:
>> Govindraj <govindraj.ti@gmail.com> writes:
>>
>>> On Fri, Jan 21, 2011 at 3:31 PM, Thomas Weber <weber@corscience.de> wrote:
>>>> Magic SysRq key is not working for OMAP on new serial
>>>> console ttyOx because SUPPORT_SYSRQ is not defined
>>>> for omap-serial.
>>>>
>>>> This patch defines SUPPORT_SYSRQ in omap-serial and
>>>> enables handling of Magic SysRq character.
>>>>
>>>> Further there is an issue of losing first break character.
>>>> Removing the reset of the lsr_break_flag fixes this issue.
>>>>
>>>> Signed-off-by: Thomas Weber <weber@corscience.de>
>>>
>>>
>>> Acked-by: Govindraj.R <govindraj.raja@ti.com>
>>> Tested-by: Manjunath G Kondaiah <manjugk@ti.com>
>>>
>>
>> Acked-by: Kevin Hilman <khilman@ti.com>
>>
>> Greg, this one should go for .38-rc.   Feel free to merge, or we can
>> take it through the OMAP tree with your ack.
>>
>> Thanks,
>>
>> Kevin
>>
>> --
>
> Hello,
> should I rebase this patch, because it does not apply after movement
> of driver/serial to driver/tty/serial?
>

Yes, please rebase.

Thanks,

Kevin

