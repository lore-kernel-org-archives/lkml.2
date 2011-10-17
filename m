Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1JQPqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:46:08 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:48229
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751512Ab1JQPqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:46:06 -0400
Message-ID: <4E9C4DAE.7020804@compulab.co.il>
Date: Mon, 17 Oct 2011 17:45:50 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: axel.lin@gmail.com, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: pxa/cm-x300: properly set bt_reset pin
References: <1316268934.16763.2.camel@phoenix> <4E7B0E35.5010607@compulab.co.il> <CAF+7xW=AFmxCmppmt81pzkDbem=LAHdSYtT67yOOzMNPFRpnfA@mail.gmail.com>
In-Reply-To: <CAF+7xW=AFmxCmppmt81pzkDbem=LAHdSYtT67yOOzMNPFRpnfA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On 09/29/11 10:57, Axel Lin wrote:
> 2011/9/22 Igor Grinberg <grinberg@compulab.co.il>:
>> Hi Axel,
>>
>> On 09/17/11 17:15, Axel Lin wrote:
>>> Fix below build warning and properly set bt_reset pin.
>>>
>>>   CC      arch/arm/mach-pxa/cm-x300.o
>>> arch/arm/mach-pxa/cm-x300.c: In function 'cm_x300_init_wi2wi':
>>> arch/arm/mach-pxa/cm-x300.c:779: warning: unused variable 'wlan_en'
>>> arch/arm/mach-pxa/cm-x300.c:795: warning: 'bt_reset' may be used uninitialized in this function
>>
>> Acked-by: Igor Grinberg <grinberg@compulab.co.il>
>>
>> Also, this patch fixes a real regression since
>> 5a009df1f200efa49658b0e9c7ad056d59fbefe4 (ARM: pxa/cm-x300: GPIO cleanup)
>> - Wifi and Bluetooth do not work without it, so please:
>>
>> Cc: <stable@kernel.org> [3.0.x]
>>
> Hi, Eric,
> Just to pin the status of this patch. I think it should go for 3.1.
> Thanks,
> Axel
> 

-- 
Regards,
Igor.
