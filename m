Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1JYOht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:37:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56780 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1JYOhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <4EA6C810.30605@compulab.co.il>
References: <1316268934.16763.2.camel@phoenix> <4E7B0E35.5010607@compulab.co.il>
 <CAF+7xW=AFmxCmppmt81pzkDbem=LAHdSYtT67yOOzMNPFRpnfA@mail.gmail.com>
 <4E9C4DAE.7020804@compulab.co.il> <4EA6C810.30605@compulab.co.il>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 25 Oct 2011 22:37:28 +0800
Message-ID: <CAMPhdO9-Y_Y8SoidmMYuuEUOZB0310_2ip0+XjEAhR3P2XWY9w@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa/cm-x300: properly set bt_reset pin
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: axel.lin@gmail.com, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry x 3

Missed this, queued now.

On Tue, Oct 25, 2011 at 10:30 PM, Igor Grinberg <grinberg@compulab.co.il> wrote:
> ping x2
>
> On 10/17/2011 05:45 PM, Igor Grinberg wrote:
>> ping
>>
>> On 09/29/11 10:57, Axel Lin wrote:
>>> 2011/9/22 Igor Grinberg <grinberg@compulab.co.il>:
>>>> Hi Axel,
>>>>
>>>> On 09/17/11 17:15, Axel Lin wrote:
>>>>> Fix below build warning and properly set bt_reset pin.
>>>>>
>>>>>   CC      arch/arm/mach-pxa/cm-x300.o
>>>>> arch/arm/mach-pxa/cm-x300.c: In function 'cm_x300_init_wi2wi':
>>>>> arch/arm/mach-pxa/cm-x300.c:779: warning: unused variable 'wlan_en'
>>>>> arch/arm/mach-pxa/cm-x300.c:795: warning: 'bt_reset' may be used uninitialized in this function
>>>> Acked-by: Igor Grinberg <grinberg@compulab.co.il>
>>>>
>>>> Also, this patch fixes a real regression since
>>>> 5a009df1f200efa49658b0e9c7ad056d59fbefe4 (ARM: pxa/cm-x300: GPIO cleanup)
>>>> - Wifi and Bluetooth do not work without it, so please:
>>>>
>>>> Cc: <stable@kernel.org> [3.0.x]
>>>>
>>> Hi, Eric,
>>> Just to pin the status of this patch. I think it should go for 3.1.
>>> Thanks,
>>> Axel
>>>
>
>
