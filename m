Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1FII4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:56:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37023 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1FII4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:56:45 -0400
Message-ID: <4DF08ACA.30507@monstr.eu>
Date: Thu, 09 Jun 2011 10:56:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: emaclite: Add missing linux/interrupt.h header
References: <1307607333-24612-1-git-send-email-monstr@monstr.eu> <20110609.012944.602872260942727070.davem@davemloft.net>
In-Reply-To: <20110609.012944.602872260942727070.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Michal Simek <monstr@monstr.eu>
> Date: Thu,  9 Jun 2011 10:15:33 +0200
> 
>> Log:
>> drivers/net/xilinx_emaclite.c: In function 'xemaclite_open':
>> drivers/net/xilinx_emaclite.c:961: error: implicit declaration of function 'request_irq'
>> drivers/net/xilinx_emaclite.c: In function 'xemaclite_close':
>> drivers/net/xilinx_emaclite.c:995: error: implicit declaration of function 'free_irq'
>> make[2]: *** [drivers/net/xilinx_emaclite.o] Error 1
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> This is only relevant for the -next tree, you should specify that when
> submitting patches otherwise the maintainer not apply the patch where
> it actually belongs.

sorry for that. Yes, it is for -next tree.

Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
