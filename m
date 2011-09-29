Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1I2H6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:58:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39763 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1I2H6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:58:16 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4E7B0E35.5010607@compulab.co.il>
References: <1316268934.16763.2.camel@phoenix> <4E7B0E35.5010607@compulab.co.il>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 29 Sep 2011 15:57:55 +0800
Message-ID: <CAF+7xW=AFmxCmppmt81pzkDbem=LAHdSYtT67yOOzMNPFRpnfA@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa/cm-x300: properly set bt_reset pin
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/22 Igor Grinberg <grinberg@compulab.co.il>:
> Hi Axel,
>
> On 09/17/11 17:15, Axel Lin wrote:
>> Fix below build warning and properly set bt_reset pin.
>>
>>   CC      arch/arm/mach-pxa/cm-x300.o
>> arch/arm/mach-pxa/cm-x300.c: In function 'cm_x300_init_wi2wi':
>> arch/arm/mach-pxa/cm-x300.c:779: warning: unused variable 'wlan_en'
>> arch/arm/mach-pxa/cm-x300.c:795: warning: 'bt_reset' may be used uninitialized in this function
>
> Acked-by: Igor Grinberg <grinberg@compulab.co.il>
>
> Also, this patch fixes a real regression since
> 5a009df1f200efa49658b0e9c7ad056d59fbefe4 (ARM: pxa/cm-x300: GPIO cleanup)
> - Wifi and Bluetooth do not work without it, so please:
>
> Cc: <stable@kernel.org> [3.0.x]
>
Hi, Eric,
Just to pin the status of this patch. I think it should go for 3.1.
Thanks,
Axel
