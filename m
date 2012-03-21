Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab2CUKqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:46:30 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:51760 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758278Ab2CUKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:46:29 -0400
Message-ID: <4F69B159.5030101@atmel.com>
Date: Wed, 21 Mar 2012 11:45:45 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com,
        mpm@selenic.com, herbert@gondor.hengli.com.au, vinod.koul@intel.com,
        a.zummo@towertech.it
Subject: Re: [PATCH 0/6] AT91 drivers Kconfig cleanup
References: <cover.1331826095.git.nicolas.ferre@atmel.com> <7104123.IANagkT9hm@dtor-d630.eng.vmware.com>
In-Reply-To: <7104123.IANagkT9hm@dtor-d630.eng.vmware.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 05:50 PM, Dmitry Torokhov :
> On Thursday, March 15, 2012 04:57:16 PM Nicolas Ferre wrote:
>> This is a series which deals with AT91 drivers Kconfig entries. Its goal is
>> to remove too restrictive dependencies on SoC names.
>> This will allow to add support for newer SoC seamlessly.
>>
>> One question remains: should I submit those patches through dedicated
>> sub-maintainer's git trees or can I queue the whole series in arm-soc?
> 
> I'm fine if you queue input piece through arm-soc.

Ok, good: I have "Acknowledgement" by several maintainers: so yes, I
will send this series via arm-soc.

Is this means that I can add your "Acked-by"?

Best regards,
-- 
Nicolas Ferre
